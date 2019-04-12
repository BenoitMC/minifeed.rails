require "rails_helper"

describe Feed::SearchService do
  let(:site_url) { "https://www.ruby-lang.org/en/" }
  let(:feed_url) { "https://www.ruby-lang.org/en/feeds/news.rss" }

  describe "on exception" do
    def self.it_should_reraise(exception)
      it "should reraise #{exception} exception" do
        instance = described_class.new(site_url)
        expect(instance).to receive(:results).and_raise(exception)
        expect {
          instance.call
        }.to raise_error(Feed::SearchService::Error, "unable to fetch or parse #{site_url}")
      end
    end

    it_should_reraise(HTTP::Error)
    it_should_reraise(Feedjira::NoParserAvailable)
  end # describe "on exception"

  describe "in real life" do
    it "should search feeds using Feedbag" do
      service = described_class.new(site_url)
      expect(Feedbag).to receive(:find).with(site_url).and_call_original
      expect(service).to receive(:provided_url_result).and_return(nil)
      results = service.call
      expect(results).to be_a Array
      expect(results.first).to be_a described_class::Result
      expect(results.first.name).to eq "Ruby News"
      expect(results.first.url).to eq feed_url
    end

    it "should try to parse provided url" do
      service = described_class.new(feed_url)
      expect(service).to receive(:feedbag_results).and_return([])
      results = service.call
      expect(results).to be_a Array
      expect(results.first.name).to eq "Ruby News"
    end

    it "should ignore provided url if it is not a valid feed" do
      service = described_class.new(site_url)
      expect(service).to receive(:feedbag_results).and_return([])
      results = service.call
      expect(results).to eq []
    end
  end # describe "in real life"
end
