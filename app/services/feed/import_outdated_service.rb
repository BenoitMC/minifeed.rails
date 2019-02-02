class Feed::ImportOutdatedService < Service
  def call
    feeds.each do |feed|
      Feed::ImportService.call(feed)
    end
  end

  def feeds
    Feed
      .where("last_update_at IS NULL OR last_update_at <= ?", max_datetime)
      .reorder(Arel.sql "last_update_at IS NOT NULL ASC, last_update_at ASC")
      .preload(:user, :category)
  end

  private

  def max_datetime
    Minifeed.config.refresh_feeds_after.ago
  end
end
