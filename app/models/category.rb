class Category < ApplicationRecord
  belongs_to :user
  has_many   :feeds, dependent: :nullify

  validates :user, presence: true
  validates :name, presence: true

  scope :order_by_name, -> { order("LOWER(#{table_name}.name) ASC") }

  default_scope -> { order(:position).order_by_name }
end
