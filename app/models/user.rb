class User < ApplicationRecord
  before_save :downcase_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_secure_password

  validates :email, format: {with: VALID_EMAIL_REGEX}, presence: true,
            length: {maximum: Settings.user_setting.email_length_max},
            uniqueness: {case_sensitive: false}

  validates :name, presence: true,
            length: {maximum: Settings.user_setting.name_length_max}

  validates :password, presence: true,
            length: {minimum: Settings.user_setting.password_length_min}

  private

  def downcase_email
    self.email = email.downcase
  end
end
