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

  has_many :categories, dependent: :destroy
  has_many :feeds,      dependent: :destroy

  has_secure_token :auth_token

  def to_s
    email
  end
end
