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

  def to_s
    email
  end
end
