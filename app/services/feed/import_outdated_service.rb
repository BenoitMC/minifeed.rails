class Feed::ImportOutdatedService < Service
  POOL = ThreadPool.new(Minifeed.config.autoimport_pool_size)
  private_constant :POOL

  def call
    return if POOL.any?

    feeds.each do |feed|
      post(feed)
    end

    POOL.wait
  end

  def feeds
    Feed
      .where("last_import_at IS NULL OR last_import_at <= ?", max_datetime)
      .reorder(Arel.sql "last_import_at IS NOT NULL ASC, last_import_at ASC")
      .preload(:user, :category)
  end

  private

  def post(feed)
    POOL.post do
      Feed::ImportService.call(feed)
    end
  end

  def max_datetime
    Minifeed.config.refresh_feeds_after.ago
  end
end
