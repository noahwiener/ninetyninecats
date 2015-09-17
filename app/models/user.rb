# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string(255)      not null
#  password_digest :string(255)      not null
#  session_token   :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base
  before_save :ensure_validation_token
  validates :password, length: { minimum: 6, allow_nil: true}

  attr_reader :password

  has_many :cats

  def self.find_by_credentials(user_name, password)
    user = User.where(user_name: user_name).first

    if user
      return user if user.is_password?(password)
      raise "password error" #if username correct but wrong password
    else
      raise "hell" #username not found
    end
  end

  def reset_session_token!
    new_token = SecureRandom.urlsafe_base64
    self.session_token = new_token
  end

  def password=(password)
    @password = password
    digested = BCrypt::Password.create(password)
    self.password_digest = digested.to_s
  end

  def is_password?(password)
    digested = BCrypt::Password.new(self.password_digest)
    digested.is_password?(password)
  end

  private
  def ensure_validation_token
    self.session_token ||= generate_session_token
  end

  def generate_session_token
    SecureRandom::urlsafe_base64
  end
end
