class User < ActiveRecord::Base
  include Orderable

  devise :database_authenticatable, :registerable, :recoverable, :validatable

  has_attached_file :avatar

  validates :username, presence: true, format: /[a-zA-Z0-9_]{3,15}/
  validates :phone_number, phony_plausible: true
  validates :auth_token, presence: true
  validates :password, length: { minimum: 5 }, allow_blank: true
  validates_attachment :avatar, content_type: { content_type: 'image/png' }

  phony_normalize :phone_number, default_country_code: 'US'

  has_many :clips, dependent: :destroy
  has_many :follows, class_name: 'Follow', foreign_key: :follower_id, dependent: :destroy # follows user has created
  has_many :followings, class_name: 'Follow', foreign_key: :following_id, dependent: :destroy # follows others have created

  before_validation(on: :create) do
    generate_auth_token
  end

  after_create do
    follow_snowball
  end

  def generate_auth_token
    loop do
      self.auth_token = Devise.friendly_token
      break unless self.class.exists?(auth_token: auth_token)
    end
  end

  def follow_snowball
    snowball_user = User.where(email: 'hello@snowball.is').first
    follow(snowball_user) unless snowball_user.nil?
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
    follows.where(following: user).first.destroy
  end
end
