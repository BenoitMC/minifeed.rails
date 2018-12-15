require "rails_helper"

describe Feed::SearchService do
  let(:url) { "https://www.ruby-lang.org/en/" }

  describe "on exception" do
    def self.it_should_reraise(exception)
      it "should reraise #{exception} exception" do
        instance = described_class.new(url)
        expect(instance).to receive(:results).and_raise(exception)
        expect {
          instance.call
        }.to raise_error(Feed::SearchService::Error, "unable to fetch or parse #{url}")
      end
    end

    it_should_reraise(Agilibox::GetHTTP::Error)
    it_should_reraise(Feedjira::NoParserAvailable)
  end # describe "on exception"

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
