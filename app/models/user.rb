class User < ApplicationRecord
  devise(
    :database_authenticatable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable,
    # :confirmable,
    # :lockable,
    # :timeoutable,
    # :omniauthable,
  )

  string_enum :theme, %w[light dark]

  has_many :categories, dependent: :destroy
  has_many :feeds,      dependent: :destroy

  has_secure_token :auth_token

  validates :name, presence: true
end
