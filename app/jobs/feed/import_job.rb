class Feed::ImportJob < ApplicationJob
  limits_concurrency key: proc(&:id), group: nil

  def perform(feed)
    Feed::ImportService.call(feed)
  end
end
