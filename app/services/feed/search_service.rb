class Feed::SearchService < ApplicationService
  Result = Struct.new(:url, :name)

  attr_reader_initialize :url

  def call
    urls = [url] + Feedbag.find(url)
    urls.uniq.map { url_to_result(it) }.compact
  end

  private

  def url_to_result(url)
    raw_feed = HttpClient.request(:get, url).to_s
    feed = Feedjira.parse(raw_feed)
    Result.new(url, feed.title)
  rescue Feedjira::NoParserAvailable
    nil
  end
end
