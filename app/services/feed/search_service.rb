class Feed::SearchService < ApplicationService
  Result = Struct.new(:url, :name)

  Error = Class.new(StandardError)

  initialize_with :url

  def call
    results
  rescue HttpClient::Error, Feedjira::NoParserAvailable
    raise Error, "unable to fetch or parse #{url}"
  end

  private

  def results
    (feedbag_results + [provided_url_result]).compact.uniq
  end

  def feedbag_results
    Feedbag.find(url).map do |feed_url|
      url_to_result(feed_url)
    end
  end

  def provided_url_result
    url_to_result(url)
  rescue Feedjira::NoParserAvailable
    nil
  end

  def url_to_result(url)
    raw_feed = HttpClient.request(:get, url).to_s
    feed = Feedjira.parse(raw_feed)
    Result.new(url, feed.title)
  end
end
