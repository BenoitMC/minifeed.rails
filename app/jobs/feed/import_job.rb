class Feed::ImportJob < ApplicationJob
  limits_concurrency key: proc(&:id), group: nil

  discard_on Exception # This job is auto enqueued periodically, so we don't need retries

  def perform(feed)
    Feed::ImportService.call(feed)
  end
end
