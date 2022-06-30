# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :articles

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  enum role: { admin: 0, user: 1, publisher: 2 }
end
