class User < ActiveRecord::Base
  has_secure_password

  include Orderable

  validates :phone_number, presence: true, phony_plausible: true
  validates :auth_token, presence: true
  validates :password, length: { minimum: 5 }

  phony_normalize :phone_number, default_country_code: 'US'

  has_many :clips
  has_many :follows, class_name: 'Follow', foreign_key: :follower_id # follows user has created
  has_many :followings, class_name: 'Follow', foreign_key: :following_id # follows others have created

  before_validation(on: :create) do
    generate_auth_token
  end

  def generate_auth_token
    loop do
      self.auth_token = SecureRandom.hex
      break unless self.class.exists?(auth_token: auth_token)
    end
  end

  def generate_phone_number_verification_code
    self.phone_number_verification_code = "#{Array.new(4) { rand 10 }.join}"
  end

  def send_verification_text
    return if Rails.env.test?
    twilio = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    twilio.messages.create(
    from: ENV['TWILIO_PHONE_NUMBER'],
    to: phone_number,
    body: "Your Snowball code is #{phone_number_verification_code}. Enjoy!"
    )
  end

  def following?(user)
    0 < follows.where(following: user).count
  end
end
