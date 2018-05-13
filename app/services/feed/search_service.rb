class Feed::SearchService < Service
  initialize_with :url

  def call
    Feedbag.find(url).map do |feed_url|
      raw_feed = GetHTTP.call(feed_url)
      feed = Feedjira::Feed.parse(raw_feed)
      Result.new(feed_url, feed.title)
    end
  end

  class Result
    include Agilibox::InitializeWith
    initialize_with :url, :name
  end
end
