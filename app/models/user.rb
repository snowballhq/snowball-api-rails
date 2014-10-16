class User < ActiveRecord::Base
  validates :phone_number, presence: true
  validates :auth_token, presence: true

  before_validation(on: :create) do
    generate_and_set_auth_token
  end

  private

  def generate_and_set_auth_token
    loop do
      self.auth_token = SecureRandom.hex
      break unless self.class.exists?(auth_token: auth_token)
    end
  end
end
