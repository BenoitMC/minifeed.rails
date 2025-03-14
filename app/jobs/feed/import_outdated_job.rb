class Feed::ImportOutdatedJob < ApplicationJob
  limits_concurrency key: name
  before_enqueue { throw :abort if SolidQueue::Job.where(concurrency_key:).any? }

  discard_on Exception # This job is auto enqueued periodically, so we don't need retries

  def perform
    Feed
      .where("last_import_at IS NULL OR last_import_at <= ?", Minifeed.config.refresh_feeds_after.ago)
      .joins("LEFT JOIN solid_queue_jobs j ON j.concurrency_key = feeds.id::text AND j.class_name = 'Feed::ImportJob'")
      .where(j: {id: nil})
      .reorder(Arel.sql "last_import_at IS NOT NULL ASC, last_import_at ASC")
      .find_each { Feed::ImportJob.perform_later(_1) }
  end
end
