require "rails_helper"

describe Feed::ImportService do
  let!(:feed) { create(:feed) }

  describe "#raw_feed" do
    let(:url) { "https://www.ruby-lang.org/en/feeds/news.rss" }
    let(:feed) { Feed.new(url:) }
    let(:raw_feed) { described_class.new(feed).send(:raw_feed) }

    it "should retrieve feed from url" do
      expect(HttpClient).to receive(:request).with(:get, url, headers: {})
        .and_return("remote content")

      expect(raw_feed).to eq "remote content"
    end

    it "should use custom user agent" do
      feed.user_agent = "curl"

      expect(HttpClient).to receive(:request).with(:get, url, headers: {user_agent: "curl"})
        .and_return("remote content")

      expect(raw_feed).to eq "remote content"
    end
  end # describe "#raw_fee"

  describe "#create_or_update_entry!" do
    let(:remote_entry) {
      OpenStruct.new(
        :name         => "entry name",
        :url          => "entry url",
        :external_id  => "entry id",
        :body         => "entry content",
        :author       => "entry author",
        :published_at => Time.utc(2012, 12, 21, 12, 0, 0),
      )
    }

    def create_or_update_entry!
      described_class.new(feed).send(:create_or_update_entry!, remote_entry)
    end

    it "should create entry" do
      expect { create_or_update_entry! }.to change(Entry, :count).by(1)

      entry = Entry.last_created
      expect(entry.user).to         eq feed.user
      expect(entry.feed).to         eq feed
      expect(entry.name).to         eq "entry name"
      expect(entry.body).to         eq "entry content"
      expect(entry.external_id).to  eq "entry id"
      expect(entry.url).to          eq "entry url"
      expect(entry.author).to       eq "entry author"
      expect(entry.published_at).to eq Time.utc(2012, 12, 21, 12, 0, 0)
    end

    it "should update entry based on external_id" do
      entry = create(:entry, user: feed.user, feed:, external_id: "entry id")

      expect { create_or_update_entry! }.to_not change(Entry, :count)

      entry.reload
      expect(entry.name).to eq "entry name"
      expect(entry.body).to eq "entry content"
      expect(entry.url).to  eq "entry url"
    end

    it "should not update other user entry with same external_id" do
      entry = create(:entry, external_id: "entry id")

      expect { create_or_update_entry! }.to change(Entry, :count).by(1)
    end

    it "should ignore entries without id" do
      remote_entry.external_id = nil

      expect { create_or_update_entry! }.to_not change(Entry, :count)
    end

    it "should assign default published_at to now" do
      remote_entry.published_at = nil

      expect { create_or_update_entry! }.to change(Entry, :count).by(1)

      expect(Entry.last_created.published_at).to be_present
    end

    it "should not update published_at if not present" do
      remote_entry.published_at = nil

      travel_to Time.utc(2012, 12, 21, 12, 0, 0)
      expect { create_or_update_entry! }.to change(Entry, :count).by(1)
      entry = Entry.last_created
      expect(entry.published_at).to eq Time.utc(2012, 12, 21, 12, 0, 0)

      travel_to Time.utc(2012, 12, 21, 15, 0, 0)
      expect { create_or_update_entry! }.to_not change(Entry, :count)
      entry.reload
      expect(entry.published_at).to eq Time.utc(2012, 12, 21, 12, 0, 0)
    end

    describe "black/white lists" do
      describe "blacklist only" do
        before do
          feed.update!(blacklist: "javascript")
        end

        it "should import entry if not in blacklist" do
          remote_entry.name = "Article about Ruby"
          expect { create_or_update_entry! }.to change(Entry, :count).by(1)
        end

        it "should not import entry if in blacklist" do
          remote_entry.name = "Article about Javascript"
          expect { create_or_update_entry! }.to_not change(Entry, :count)
        end
      end # describe "blacklist only"

      describe "whitelist only" do
        before do
          feed.update!(whitelist: "ruby")
        end

        it "should import entry if in whitelist" do
          remote_entry.name = "Article about Ruby"
          expect { create_or_update_entry! }.to change(Entry, :count).by(1)
        end

        it "should not import entry if not in whitelist" do
          remote_entry.name = "Article about Javascript"
          expect { create_or_update_entry! }.to_not change(Entry, :count)
        end
      end # describe "whitelist only"

      describe "blacklist and whitelist" do
        before do
          feed.update!(blacklist: "javascript", whitelist: "ruby")
        end

        it "should import entry if in whitelist" do
          remote_entry.name = "Article about Ruby"
          expect { create_or_update_entry! }.to change(Entry, :count).by(1)
        end

        it "should not import entry if in whitelist and blacklist" do
          remote_entry.name = "Article about Javascript and Ruby"
          expect { create_or_update_entry! }.to_not change(Entry, :count)
        end
      end # describe "blacklist and whitelist"
    end # describe "black/white lists"
  end # describe "#create_or_update_entry!"

  describe "#remote_entries" do
    it "should parse raw feed and return entry adapters" do
      service = described_class.new(nil)
      raw_feed = fixture_content("feed.atom.xml")
      expect(service).to receive(:raw_feed).and_return(raw_feed)
      entries = service.send(:remote_entries)
      expect(entries.length).to eq 1
      expect(entries.first).to be_a EntryAdapter
      expect(entries.first.name).to eq "Atom Entry Name"
    end
  end # describe "#remote_entries"

  describe "#call" do
    it "should call create_or_update_entry! for each entry" do
      remote_entries = %w[remote_entry1 remote_entry2]

      service = described_class.new(feed)
      expect(service).to receive(:remote_entries).at_least(:once).and_return(remote_entries)
      expect(service).to receive(:create_or_update_entry!).with("remote_entry1")
      expect(service).to receive(:create_or_update_entry!).with("remote_entry2")
      service.call
    end

    it "should update #last_import_at field with current time" do
      feed.update!(last_import_at: nil)
      expect_any_instance_of(described_class).to receive(:remote_entries).and_return([])

      time = Time.zone.now.round
      travel_to time

      described_class.call(feed)
      expect(feed.reload.last_import_at).to eq time
    end

    it "should catch http errors" do
      expect_any_instance_of(described_class).to \
        receive(:raw_feed) { raise HTTP::Error }

      feed.update!(last_import_at: nil)
      expect(feed.import_errors).to eq 0
      expect { described_class.call(feed) }.to_not raise_error
      expect(feed.import_errors).to eq 1
      expect(feed.last_import_at).to be_present
    end

    it "should catch feedjira errors" do
      expect_any_instance_of(described_class).to \
        receive(:raw_feed) { raise Feedjira::NoParserAvailable }

      feed.update!(last_import_at: nil)
      expect(feed.import_errors).to eq 0
      expect { described_class.call(feed) }.to_not raise_error
      expect(feed.import_errors).to eq 1
      expect(feed.last_import_at).to be_present
    end

    it "should reset errors on success" do
      expect_any_instance_of(described_class).to \
        receive(:remote_entries).at_least(:once).and_return([])

      feed.update!(import_errors: 1)
      described_class.call(feed)
      expect(feed.import_errors).to eq 0
    end
  end # describe "#call"
end
