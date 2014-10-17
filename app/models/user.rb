class User < ActiveRecord::Base
  validates :phone_number, presence: true, phony_plausible: true
  validates :auth_token, presence: true

  phony_normalize :phone_number, default_country_code: 'US'

  before_validation(on: :create) do
    generate_auth_token
  end

  def generate_auth_token
    loop do
      self.auth_token = SecureRandom.hex
      break unless self.class.exists?(auth_token: auth_token)
    end
  end
end
