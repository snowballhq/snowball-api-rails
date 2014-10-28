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
    it { is_expected.to have_many(:clips) }
    it { is_expected.to have_many(:followings).class_name('Follow') }
    it { is_expected.to have_many(:follows).class_name('Follow') }
  end

  describe 'before_validation(on: :create)' do
    it 'generates a new auth token' do
      expect(user).to receive(:generate_auth_token)
      user.valid?
    end
  end

  # TODO: write validation to ensure name exists after initial sign up
  # describe 'before_validation(on: :update)' do
  #   context 'when the user is verified' do
  #     it 'is not valid without a name' do
  #       user.name = nil
  #       user.phone_number_verification_code = nil
  #       expect(user.valid?).to be_falsy
  #     end
  #   end
  #   context 'when the user is not verified' do
  #     it 'is valid without a name' do
  #       user.name = nil
  #       user.phone_number_verification_code = '1234'
  #       expect(user.valid?).to be_truthy
  #     end
  #   end
  # end

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

  describe '#following?(user)' do
    it 'returns true if the user is following the user' do
      follow = create(:follow)
      expect(follow.follower.following?(follow.following)).to be_truthy
    end
    it 'returns false if the user is not following the user' do
      user = create(:user)
      user2 = create(:user)
      expect(user.following?(user2)).to be_falsy
    end
  end
end
