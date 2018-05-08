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

  describe "#feed_entries" do
    it "should return Atom entries" do
      raw_atom_feed = Rails.root.join("spec", "fixtures", "feed.atom.xml").read
      allow_any_instance_of(described_class).to receive(:raw_feed).and_return(raw_atom_feed)

      feed_entries = described_class.new(nil).send(:feed_entries)
      expect(feed_entries.count).to eq 1

      feed_entry = feed_entries.first
      expect(feed_entry.title).to     eq "Atom Entry Name"
      expect(feed_entry.url).to       eq "http://atom.example.org/1"
      expect(feed_entry.id).to        eq "atom-entry-id"
      expect(feed_entry.published).to eq Time.utc(2012, 12, 21, 12, 0, 0)
      expect(feed_entry.summary).to   eq "Atom Entry Summary"
      expect(feed_entry.author).to    eq "Atom Entry Author"
    end

    it "should return RSS entries" do
      raw_rss_feed = Rails.root.join("spec", "fixtures", "feed.rss.xml").read
      allow_any_instance_of(described_class).to receive(:raw_feed).and_return(raw_rss_feed)

      feed_entries = described_class.new(nil).send(:feed_entries)
      expect(feed_entries.count).to eq 1

      feed_entry = feed_entries.first
      expect(feed_entry.title).to     eq "RSS Entry Name"
      expect(feed_entry.url).to       eq "http://rss.example.org/1"
      expect(feed_entry.id).to        eq "rss-entry-id"
      expect(feed_entry.published).to eq Time.utc(2012, 12, 21, 12, 0, 0)
      expect(feed_entry.summary).to   eq "RSS Entry Summary"
      expect(feed_entry.author).to    eq "RSS Entry Author"
    end

    it "should sanitize entries" do
      raw_rss_feed = Rails.root.join("spec", "fixtures", "feed.sanitize_me.atom.xml").read
      allow_any_instance_of(described_class).to receive(:raw_feed).and_return(raw_rss_feed)

      feed_entry = described_class.new(nil).send(:feed_entries).first
      expect(feed_entry.summary).to_not include "script"
      expect(feed_entry.summary).to_not include "onclick"
      expect(feed_entry.summary).to     include "style"
    end
  end # describe "#feed_entries"

  describe "#create_or_update_entry!" do
    let(:feed) { create(:feed) }

    let(:feed_entry) {
      OpenStruct.new(
        :title     => "entry title",
        :url       => "entry url",
        :id        => "entry id",
        :summary   => "entry summary",
        :content   => "entry content",
        :author    => "entry author",
        :published => Time.utc(2012, 12, 21, 12, 0, 0),
      )
    }

    def create_or_update_entry!
      described_class.new(feed).send(:create_or_update_entry!, feed_entry)
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

    it "should assign a default title if needed" do
      feed_entry.title = nil

      expect { create_or_update_entry! }.to change(Entry, :count).by(1)

      entry = Entry.last_created
      expect(entry.name).to eq "[no title]"
    end

    it "should use summary if content if empty" do
      feed_entry.content = nil

      expect { create_or_update_entry! }.to change(Entry, :count).by(1)

      entry = Entry.last_created
      expect(entry.body).to eq "entry summary"
    end

    it "should ignore entries without id" do
      feed_entry.id = nil

      expect { create_or_update_entry! }.to_not change(Entry, :count)
    end

    it "should assign default published_at to now" do
      feed_entry.published = nil

      expect { create_or_update_entry! }.to change(Entry, :count).by(1)

      expect(Entry.last_created.published_at).to be_present
    end

    it "should not update published_at if not present" do
      feed_entry.published = nil

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

  describe "#call" do
    it "should call create_or_update_entry! for each entry" do
      feed_entry1 = OpenStruct.new(title: "entry1")
      feed_entry2 = OpenStruct.new(title: "entry2")
      feed        = create(:feed)

      service = described_class.new(feed)
      expect(service).to receive(:feed_entries).and_return([feed_entry1, feed_entry2])
      expect(service).to receive(:create_or_update_entry!).with(feed_entry1)
      expect(service).to receive(:create_or_update_entry!).with(feed_entry2)
      service.call
    end

    it "should update #last_update_at field" do
      feed = create(:feed)
      expect(feed.last_update_at).to be nil

      allow_any_instance_of(described_class).to receive(:feed_entries).and_return([])

      described_class.call(feed)
      expect(feed.reload.last_update_at).to be_present
    end

    it "should skip existing entries based on #last_update_at" do
      feed = create(:feed, last_update_at: Date.new(2012, 12, 15))
      feed_entry = OpenStruct.new(published: Date.new(2012, 12, 10))
      service = described_class.new(feed)

      expect(service).to receive(:feed_entries).and_return([feed_entry])
      expect(service).to_not receive(:create_or_update_entry!)

      service.call
    end

    it "should not skip updated existing entries" do
      feed = create(:feed, last_update_at: Date.new(2012, 12, 15))

      feed_entry = OpenStruct.new(published: Date.new(2012, 12, 10), updated: Date.new(2013, 1, 1))
      service = described_class.new(feed)

      expect(service).to receive(:feed_entries).and_return([feed_entry])
      expect(service).to receive(:create_or_update_entry!).with(feed_entry)

      service.call
    end

    it "should not crash on feeds without updated field" do
      feed    = create(:feed)
      service = described_class.new(feed)

      expect(service).to receive(:feed_entries).and_return([Feedjira::Parser::ITunesRSSItem.new])
      allow(service).to receive(:create_or_update_entry!)

      expect { service.call }.to_not raise_error
    end
  end # describe "#call"

  describe "errors" do
    def self.it_should_catch_error(error)
      it "should catch #{error} errors" do
        expect_any_instance_of(described_class).to receive(:raw_feed) { raise error }

        feed = create(:feed)
        expect(feed.import_errors).to eq 0
        expect { described_class.call(feed) }.to_not raise_error
        expect(feed.import_errors).to eq 1
      end
    end

    it_should_catch_error Errno::ECONNREFUSED
    it_should_catch_error Net::HTTPBadResponse
    it_should_catch_error OpenSSL::SSL::SSLError
    it_should_catch_error SocketError
    it_should_catch_error Timeout::Error
  end # describe "errors"
end
