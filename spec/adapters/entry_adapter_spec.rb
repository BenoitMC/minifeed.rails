require "rails_helper"

describe EntryAdapter do
  let(:remote_entry) {
    OpenStruct.new(
      :title     => "entry title",
      :url       => "entry url",
      :id        => "entry id",
      :summary   => "entry summary",
      :content   => "entry content",
      :author    => "entry author",
      :published => Time.utc(2012, 12, 21, 12, 0, 0),
      :updated   => Time.utc(2012, 12, 21, 15, 0, 0),
    )
  }

  let(:adapter) { described_class.new(remote_entry) }

  describe "#external_id" do
    it "should return id" do
      expect(adapter.external_id).to eq "entry id"
    end

    it "should use url if id is empty" do
      remote_entry.id = nil
      expect(adapter.external_id).to eq "entry url"
    end
  end # describe "#external_id"

  describe "#name" do
    it "should return content" do
      expect(adapter.name).to eq "entry title"
    end

    it "should strip original name" do
      remote_entry.title = " hello "
      expect(adapter.name).to eq "hello"
    end

    it "should assign default title" do
      remote_entry.title = nil
      expect(adapter.name).to eq "[no title]"
    end
  end # describe "name"

  describe "#body" do
    it "should return content" do
      expect(adapter.body).to eq "entry content"
    end

    it "should use summary if content is empty" do
      remote_entry.content = nil
      expect(adapter.body).to eq "entry summary"
    end
  end # describe "body"

  describe "#published_at" do
    it "should return published" do
      expect(adapter.published_at).to eq Time.utc(2012, 12, 21, 12, 0, 0)
    end
  end # describe "#published_at"

  describe "#updated_at" do
    it "should return updated" do
      expect(adapter.updated_at).to eq Time.utc(2012, 12, 21, 15, 0, 0)
    end

    it "should use published if updated is nil" do
      remote_entry.updated = nil
      expect(adapter.updated_at).to eq Time.utc(2012, 12, 21, 12, 0, 0)
    end

    it "should not crash on feeds without updated field" do
      adapter = described_class.new(Feedjira::Parser::ITunesRSSItem.new)
      expect(adapter.updated_at).to eq nil
    end
  end # describe "#updated_at"

  describe "#author" do
    it "should return author" do
      expect(adapter.author).to eq "entry author"
    end
  end # describe "author"

  describe "#url" do
    it "should return url" do
      expect(adapter.url).to eq "entry url"
    end
  end # describe "url"

  describe "with real feeds" do
    def parse_feed(file)
      raw_rss_feed = Rails.root.join("spec", "fixtures", file).read
      remote_entries = Feedjira::Feed.parse(raw_rss_feed).entries
      expect(remote_entries.length).to eq 1
      described_class.new(remote_entries.first)
    end

    it "should sanitize feed entry" do
      adapter = parse_feed("feed.sanitize_me.atom.xml")

      expect(adapter.body).to_not include "script"
      expect(adapter.body).to_not include "onclick"
      expect(adapter.body).to     include "style"
    end

    it "should return Atom entries" do
      adapter = parse_feed("feed.atom.xml")

      expect(adapter.name).to         eq "Atom Entry Name"
      expect(adapter.url).to          eq "http://atom.example.org/1"
      expect(adapter.external_id).to  eq "atom-entry-id"
      expect(adapter.published_at).to eq Time.utc(2012, 12, 21, 12, 0, 0)
      expect(adapter.body).to         eq "Atom Entry Summary"
      expect(adapter.author).to       eq "Atom Entry Author"
    end

    it "should return RSS entries" do
      adapter = parse_feed("feed.rss.xml")

      expect(adapter.name).to         eq "RSS Entry Name"
      expect(adapter.url).to          eq "http://rss.example.org/1"
      expect(adapter.external_id).to  eq "rss-entry-id"
      expect(adapter.published_at).to eq Time.utc(2012, 12, 21, 12, 0, 0)
      expect(adapter.body).to         eq "RSS Entry Summary"
      expect(adapter.author).to       eq "RSS Entry Author"
    end
  end # describe "IRL"
end
