require "loofah/helpers"

class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :feed

  delegate :category, to: :feed, allow_nil: true

  validates :user,         presence: true
  validates :external_id,  presence: true
  validates :name,         presence: true
  validates :published_at, presence: true
  validates :is_read,      inclusion: {in: [true, false]}
  validates :is_starred,   inclusion: {in: [true, false]}

  default_scope -> {
    order(published_at: :desc)
  }

  scope :unread,  -> { where(is_read: false)   }
  scope :starred, -> { where(is_starred: true) }

  scope :with_category_id, -> (category_id) {
    joins(:feed).where(feeds: {category_id:})
  }

  before_save :set_search_columns

  def is_unread?
    !is_read?
  end

  def self.search(q, column)
    return none unless column.to_s.in?(%w[name keywords])

    super(q, ["#{table_name}.#{column}_for_search"], unaccent: false)
  end

  private

  def set_search_columns
    self.name_for_search = normalize_for_search(name)
    self.keywords_for_search = normalize_for_search([name, body, author].compact.join(" "))
  end

  def normalize_for_search(str)
    str.to_s
      .then { Loofah::Helpers.strip_tags(_1) }
      .parameterize(separator: " ")
      .split
      .uniq
      .sort
      .join(" ")
      .then { " #{_1} " }
  end
end
