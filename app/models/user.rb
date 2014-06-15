class User < ActiveRecord::Base
  include Orderable

  devise :database_authenticatable, :registerable, :recoverable, :validatable

  has_many :clips
  has_many :follows, dependent: :destroy # follows user has created
  has_many :followings, as: :followable, dependent: :destroy, class_name: 'Follow' # follows others have created
  has_many :notifications
  has_many :identities, dependent: :destroy

  validates :name, presence: true
  validates :auth_token, presence: true
  validates :username, presence: true, format: /\A\w{1,30}\z/, uniqueness: true
  # email/password validations are handled by :validatable in devise

  has_attached_file :avatar
  validates_attachment_file_name :avatar, matches: [/png\Z/, /jpe?g\Z/]

  before_validation(on: :create) do
    generate_auth_token
    generate_username unless username.present?
  end

  def self.get_facebook_profile(access_token)
    graph = Koala::Facebook::API.new access_token
    profile = graph.get_object('me')
    profile.symbolize_keys if profile
  end

  def self.find_or_create_by_auth_hash(auth_hash)
    identity = Identity.find_by_auth_hash auth_hash
    unless identity
      user = User.where(email: auth_hash[:email]).first
      unless user
        user = User.create!(email: auth_hash[:email], name: auth_hash[:name], password: SecureRandom.hex, avatar: auth_hash[:avatar])
      end
      identity = user.identities.create_with_auth_hash auth_hash
    end
    identity.user
  end

  def avatar_url
    # TODO: think of a more elegant solution for default urls
    return nil unless avatar_file_name
    avatar.url
  end

  def following?(followable)
    return true if self.follows.where(followable: followable).count > 0
    false
  end

  private

  def generate_auth_token
    loop do
      self.auth_token = SecureRandom.hex
      break unless self.class.exists?(auth_token: auth_token)
    end
  end

  def generate_username
    count = 0
    loop do
      truncate_length = count == 0 ? 30 : (30 - count.to_s.length)
      self.username = "#{email.split('@')[0].downcase.gsub(/[^0-9A-Za-z]/, '').truncate(truncate_length, omission: '')}#{count.to_s if count > 0}"
      count += 1
      break unless self.class.exists?(username: username)
    end
  end
end
