class Player < ActiveRecord::Base
  has_secure_password

  default_scope -> { order('rating DESC') }
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  validates :name, presence: true, length: { maximum: 20, minimum: 3 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true,
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }

  def Player.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Player.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end

  private

  def create_remember_token
    self.remember_token = Player.encrypt(Player.new_remember_token)
  end
end