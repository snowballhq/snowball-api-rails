require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  it { is_expected.to be_valid }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:phone_number) }
    it 'validates presence of :auth_token' do
      allow(user).to receive(:generate_auth_token)
      expect(user).to validate_presence_of(:auth_token)
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:participations) }
    it { is_expected.to have_many(:reels).through(:participations) }
  end

  describe 'before_validation(on: :create)' do
    it 'generates a new auth token' do
      expect(user).to receive(:generate_auth_token)
      user.valid?
    end
  end

  describe '#generate_auth_token' do
    it 'generates a new auth token' do
      expect { user.save }.to change { user.auth_token }.from(nil).to(a_string_matching(/[0-9a-f]{32}/))
    end
  end

  describe '#generate_phone_number_verification_code' do
    it 'generates a new verification code' do
      expect { user.generate_phone_number_verification_code }.to change { user.phone_number_verification_code }.from(nil).to(a_string_matching(/[0-9]{4}/))
    end
  end

  describe '#send_verification_text' do
    it 'sends the user a text message with the verification code' do
      # TODO: finish writing this spec with webmock
    end
  end
end
