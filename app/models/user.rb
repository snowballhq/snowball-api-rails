class User < ActiveRecord::Base
  include Orderable

  has_secure_password

  has_attached_file :avatar

  validates :email, presence: true, format: /\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/, uniqueness: { case_sensitive: false }
  validates :username, presence: true, format: /[a-zA-Z0-9_]{3,15}/, length: { minimum: 3 }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 5 }
  validates :phone_number, phony_plausible: true
  validates :auth_token, presence: true
  validates_attachment :avatar, content_type: { content_type: 'image/png' }

  phony_normalize :phone_number, default_country_code: 'US'

  has_many :clips, dependent: :destroy
  has_many :follows, class_name: 'Follow', foreign_key: :follower_id, dependent: :destroy # follows user has created
  has_many :followings, class_name: 'Follow', foreign_key: :following_id, dependent: :destroy # follows others have created
  has_many :likes, dependent: :destroy

  before_validation(on: :create) do
    generate_auth_token
  end

  after_create do
    follow_snowball
    follow_snowboard
  end

  def generate_auth_token
    loop do
      # From Devise.friendly_token
      length = 20
      rlength = (length * 3) / 4
      self.auth_token = SecureRandom.urlsafe_base64(rlength).tr('lIO0', 'sxyz')
      break unless self.class.exists?(auth_token: auth_token)
    end
  end

  def follow_snowball
    snowball_user = User.find_by(email: 'hello@snowball.is')
    follow(snowball_user) unless snowball_user.nil?
  end

  def follow_snowboard
    follow(User.snowboard_user) unless User.snowboard_user.nil?
  end

  def following?(user)
    0 < follows.where(following: user).count
  end

  def follow(user)
    return if following?(user)
    return if self == user
    follows.create!(following: user)
  end

  def unfollow(user)
    follows.find_by(following: user).destroy
  end

  def self.snowboard_user
    User.find_by(email: 'onboarding@snowball.is')
  end
end
