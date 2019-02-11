class Feed::ImportOutdatedService < Service
  def call
    feeds.each do |feed|
      Feed::ImportService.call(feed)
    end
  end

  def feeds
    Feed
      .where("last_import_at IS NULL OR last_import_at <= ?", max_datetime)
      .reorder(Arel.sql "last_import_at IS NOT NULL ASC, last_import_at ASC")
      .preload(:user, :category)
  end

  private

  def max_datetime
    Minifeed.config.refresh_feeds_after.ago
  end
end
