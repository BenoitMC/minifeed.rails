class Category < ApplicationRecord
  belongs_to :user
  has_many   :feeds, dependent: :nullify

  validates :user, presence: true
  validates :name, presence: true
end
