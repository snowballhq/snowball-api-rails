class User < ActiveRecord::Base
  include Orderable

  devise :database_authenticatable, :registerable, :recoverable, :validatable

  validates :username, presence: true
  validates :phone_number, phony_plausible: true
  validates :auth_token, presence: true
  validates :password, length: { minimum: 5 }, allow_blank: true

  phony_normalize :phone_number, default_country_code: 'US'

  has_many :clips
  has_many :follows, class_name: 'Follow', foreign_key: :follower_id # follows user has created
  has_many :followings, class_name: 'Follow', foreign_key: :following_id # follows others have created

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
    follows.create!(following: snowball_user) unless snowball_user.nil?
  end

  def following?(user)
    0 < follows.where(following: user).count
  end
end
