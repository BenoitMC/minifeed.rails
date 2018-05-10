class Feed < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many   :entries, dependent: :destroy

  validates :user,     presence: true
  validates :category, presence: true
  validates :name,     presence: true
  validates :url,      presence: true

  validate :validate_associations_consistency

  scope :order_by_name, -> { order("LOWER(#{table_name}.name) ASC") }

  default_scope -> { order_by_name }

  private

  def validate_associations_consistency
    if user && category && category.user != user
      errors.add(:category, :invalid)
    end
  end
end
