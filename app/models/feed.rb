class Feed < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many   :entries, dependent: :destroy

  validates :user,     presence: true
  validates :category, presence: true
  validates :name,     presence: true
  validates :url,      presence: true

  validate :validate_associations_consistency

  scope :order_by_name, -> { order(Arel.sql "LOWER(#{table_name}.name) ASC") }

  default_scope -> { order_by_name }

  def on_error?
    import_errors > 10
  end

  def normalized_blacklist
    @normalized_blacklist ||= normalize_list(blacklist)
  end

  def normalized_whitelist
    @normalized_whitelist ||= normalize_list(whitelist)
  end

  private

  def validate_associations_consistency
    if user && category && category.user != user
      errors.add(:category, :invalid)
    end
  end

  def normalize_list(list)
    list.to_s.split("\n").map { |e| e.parameterize.strip.presence }.compact
  end
end
