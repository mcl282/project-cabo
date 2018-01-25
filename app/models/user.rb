class User < ApplicationRecord
  has_one :transfer_customer
  has_many :plaid_credentials
  
  #The lessor receives payment from the tenant
  has_many :lessors, class_name: "Unit", foreign_key: "manager_id", dependent: :destroy
  #The lessee pays rent to the landlord 
  has_many :lessees, class_name: "Unit", foreign_key: "tenant_id", dependent: :destroy
  
  has_many :tenants, through: :lessors
  has_many :managers, through: :lessees


  
  has_secure_password
  attr_accessor :reset_token  
  before_save   :downcase_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
            length: { maximum: 255 }, 
            format: { with: VALID_EMAIL_REGEX}, 
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, 
            length: { minimum: 6 }

  #Returns the hash digest of the given string
  def User.digest(string)
   cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
   BCrypt::Password.create(string, cost: cost)
  end

#returns true if the given token matches the digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil? #this is the remember in mult browsers, but log out 1 bug
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest:  User.digest(reset_token), reset_sent_at: Time.zone.now)
  end
  
  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  #returns true if a password reset has expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end


end
