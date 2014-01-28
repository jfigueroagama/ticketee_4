class User < ActiveRecord::Base
  has_secure_password
  has_many :tickets
  has_many :comments
  has_many :permissions
  before_create :generate_access_token
  
  validates :email, presence: true
  
  # This overrides the to_s ruby method
  def to_s
    "#{email} (#{admin? ? "Admin":"User"})"
  end
  
  private
  
  def generate_access_token
    begin
      self.access_token = SecureRandom.uuid
    end while self.class.exists?(access_token: access_token)
  end
  
end
