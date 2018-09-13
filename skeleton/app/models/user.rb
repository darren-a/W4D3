class User < ApplicationRecord
  validates :user_name, :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  after_initialize :ensure_session_token
  attr_reader :password
  
  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    user && user.is_password?(password) ? user : nil
  end
  
  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end
  
  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save!
    self.session_token
  end
  
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
  
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
  
  has_many :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: 'Cat'
end