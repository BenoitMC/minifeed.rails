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

  validates :first_name, presence: true
  validates :last_name,  presence: true

  def name
    [first_name, last_name].select(&:present?).join(" ")
  end

  def to_s
    name
  end
end
