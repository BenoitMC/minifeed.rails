class User < ApplicationRecord
  string_enum :theme, %w[light dark]

  has_many :categories, dependent: :destroy
  has_many :feeds,      dependent: :destroy

  has_secure_password
  has_secure_token :auth_token

  normalizes :email, with: -> { it&.strip&.downcase }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, unless: :password_digest
  validates :password, length: { minimum: 8 }, if: :password

  before_save :reset_auth_token, if: :password_digest_changed?

  private

  def reset_auth_token
    self.auth_token = self.class.generate_unique_secure_token
  end
end
