class Feed::SearchService < Service
  Result = Struct.new(:url, :name)

  Error = Class.new(StandardError)

  initialize_with :url

  def call
    results
  rescue GetHTTP::Error, Feedjira::NoParserAvailable
    raise Error, "unable to fetch or parse #{url}"
  end

  private

  def results
    Feedbag.find(url).map do |feed_url|
      raw_feed = GetHTTP.call(feed_url)
      feed = Feedjira::Feed.parse(raw_feed)
      Result.new(feed_url, feed.title)
    end
  end
end
