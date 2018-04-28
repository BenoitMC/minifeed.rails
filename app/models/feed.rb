class Feed < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :user,     presence: true
  validates :category, presence: true
  validates :name,     presence: true
  validates :url,      presence: true

  validate :validate_associations_consistency

  private

  def validate_associations_consistency
    if user && category && category.user != user
      errors.add(:category, :invalid)
    end
  end
end
