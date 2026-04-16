class Feed::ImportOutdatedJob < ApplicationJob
  limits_concurrency key: name
  unique_job!

  discard_on Exception # This job is auto enqueued periodically, so we don't need retries

  def perform
    Feed
      .where("last_import_at IS NULL OR last_import_at <= ?", Minifeed.config.refresh_feeds_after.ago)
      .reorder("last_import_at ASC NULLS FIRST")
      .find_each { Feed::ImportJob.perform_later(it) }
  end
end
