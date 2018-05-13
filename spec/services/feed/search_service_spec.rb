require "rails_helper"

describe Feed::SearchService do
  let(:url) { "https://www.ruby-lang.org/en/" }

  describe "in real life" do
    it "should return feed" do
      result = described_class.call(url)
      expect(result).to be_a Array
      expect(result.first).to be_a described_class::Result
      expect(result.first.name).to eq "Ruby News"
      expect(result.first.url).to eq "https://www.ruby-lang.org/en/feeds/news.rss"
    end
  end # describe "in real life"
end
