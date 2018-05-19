class EntrySerializer < ApplicationSerializer
  include ActionView::Helpers::DateHelper

  def attributes
    [
      :author,
      :body,
      :category_name,
      :feed_name,
      :id,
      :is_read,
      :is_starred,
      :name,
      :published_at_human,
      :url,
    ]
  end

  def published_at_human
    time_ago_in_words(published_at)
  end

  delegate :name, to: :feed,     prefix: true
  delegate :name, to: :category, prefix: true
end
