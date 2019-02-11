require "rails_helper"

describe Feed::ImportService do
  describe "#raw_feed" do
    it "should retrieve raw_feed in real life" do
      feed     = Feed.new(url: "https://www.ruby-lang.org/en/feeds/news.rss")
      service  = described_class.new(feed)
      raw_feed = service.send(:raw_feed)

      expect(raw_feed).to be_kind_of String
      expect(raw_feed).to include "Ruby News"
    end
  end # describe "#raw_fee"

  describe "#create_or_update_entry!" do
    let(:feed) { create(:feed) }

    let(:remote_entry) {
      OpenStruct.new(
        :name         => "entry title",
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
      expect(entry.name).to         eq "entry title"
      expect(entry.body).to         eq "entry content"
      expect(entry.external_id).to  eq "entry id"
      expect(entry.url).to          eq "entry url"
      expect(entry.author).to       eq "entry author"
      expect(entry.published_at).to eq Time.utc(2012, 12, 21, 12, 0, 0)
    end

    it "should update entry based on external_id" do
      entry = create(:entry, user: feed.user, feed: feed, external_id: "entry id")

      expect { create_or_update_entry! }.to_not change(Entry, :count)

      entry.reload
      expect(entry.name).to eq "entry title"
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

      Timecop.freeze Time.utc(2012, 12, 21, 12, 0, 0)
      expect { create_or_update_entry! }.to change(Entry, :count).by(1)
      entry = Entry.last_created
      expect(entry.published_at).to eq Time.utc(2012, 12, 21, 12, 0, 0)

      Timecop.freeze Time.utc(2012, 12, 21, 15, 0, 0)
      expect { create_or_update_entry! }.to_not change(Entry, :count)
      entry.reload
      expect(entry.published_at).to eq Time.utc(2012, 12, 21, 12, 0, 0)
    end
  end # describe "#create_or_update_entry!"

  describe "#remote_entries" do
    it "should parse raw feed and return entry adapters" do
      service = described_class.new(nil)
      raw_feed = Rails.root.join("spec", "fixtures", "feed.atom.xml").read
      expect(service).to receive(:raw_feed).and_return(raw_feed)
      entries = service.send(:remote_entries)
      expect(entries.length).to eq 1
      expect(entries.first).to be_a EntryAdapter
      expect(entries.first.name).to eq "Atom Entry Name"
    end
  end # describe "#remote_entries"

  describe "#call" do
    it "should call create_or_update_entry! for each entry" do
      remote_entry1  = OpenStruct.new(title: "entry1")
      remote_entry2  = OpenStruct.new(title: "entry2")
      remote_entries = [remote_entry1, remote_entry2]
      feed           = create(:feed)

      service = described_class.new(feed)
      expect(service).to receive(:remote_entries).at_least(:once).and_return(remote_entries)
      expect(service).to receive(:create_or_update_entry!).with(remote_entry1)
      expect(service).to receive(:create_or_update_entry!).with(remote_entry2)
      service.call
    end

    it "should update #last_import_at field with current time" do
      feed = create(:feed, last_import_at: nil)
      expect_any_instance_of(described_class).to receive(:remote_entries).and_return([])

      time = Time.zone.now.round
      Timecop.freeze time

      described_class.call(feed)
      expect(feed.reload.last_import_at).to eq time
    end

    it "should catch http errors" do
      expect_any_instance_of(described_class).to \
        receive(:raw_feed) { raise Agilibox::GetHTTP::Error }

      feed = create(:feed, last_import_at: nil)
      expect(feed.import_errors).to eq 0
      expect { described_class.call(feed) }.to_not raise_error
      expect(feed.import_errors).to eq 1
      expect(feed.last_import_at).to be_present
    end

    it "should catch feedjira errors" do
      expect_any_instance_of(described_class).to \
        receive(:raw_feed) { raise Feedjira::NoParserAvailable }

      feed = create(:feed, last_import_at: nil)
      expect(feed.import_errors).to eq 0
      expect { described_class.call(feed) }.to_not raise_error
      expect(feed.import_errors).to eq 1
      expect(feed.last_import_at).to be_present
    end

    it "should reset errors on success" do
      expect_any_instance_of(described_class).to \
        receive(:remote_entries).at_least(:once).and_return([])

      feed = create(:feed, import_errors: 1)
      described_class.call(feed)
      expect(feed.import_errors).to eq 0
    end
  end # describe "#call"
end
