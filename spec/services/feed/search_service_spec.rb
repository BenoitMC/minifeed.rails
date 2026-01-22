require "rails_helper"

describe Feed::SearchService do
  let(:site_url) { "https://www.ruby-lang.org/en/" }
  let(:feed_url) { "https://www.ruby-lang.org/en/feeds/news.rss" }

  it "should return parsable feeds" do
    service = described_class.new(site_url)
    expect(Feedbag).to receive(:find).with(site_url).and_return([feed_url])
    expect(HttpClient).to receive(:request).with(:get, site_url).and_return("invalid content")
    expect(HttpClient).to receive(:request).with(:get, feed_url).and_return(file_fixture("feed.rss.xml").read)
    results = service.call
    expect(results).to be_a Array
    expect(results.length).to eq 1
    expect(results.first).to be_a described_class::Result
    expect(results.first.name).to eq "RSS Example Feed"
    expect(results.first.url).to eq feed_url
  end
end
