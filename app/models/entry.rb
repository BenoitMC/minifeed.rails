require "loofah/helpers"

class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :feed

  delegate :category, to: :feed, allow_nil: true

  validates :user,         presence: true
  validates :external_id,  presence: true
  validates :name,         presence: true
  validates :published_at, presence: true
  validates :is_read,      inclusion: { in: [true, false] }
  validates :is_starred,   inclusion: { in: [true, false] }

  default_scope lambda {
    order(published_at: :desc)
  }

  scope :unread,  -> { where(is_read: false)   }
  scope :starred, -> { where(is_starred: true) }

  scope :with_category_id, lambda { |category_id|
    feed_ids = Feed.where(category_id:).select(:id).reorder(nil)
    where(feed_id: feed_ids)
  }

  before_save :set_search_columns

  def is_unread?
    !is_read?
  end

  def self.search(query, column)
    column = "keywords" unless column.to_s.in?(%w[name keywords])

    super(query, ["#{table_name}.#{column}_for_search"], unaccent: false)
  end

  private

  def set_search_columns
    self.name_for_search = normalize_for_search(name)
    self.keywords_for_search = normalize_for_search([name, body, author].compact.join(" "))
  end

  def normalize_for_search(str)
    str.to_s
      .then { Loofah::Helpers.strip_tags(it) }
      .parameterize(separator: " ")
      .split
      .uniq
      .sort
      .join(" ")
      .then { " #{it} " }
  end
end
