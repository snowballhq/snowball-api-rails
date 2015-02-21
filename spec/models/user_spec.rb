require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  it { is_expected.to be_valid }

  describe 'has_secure_password' do
    it 'fails without a password' do
      user.password = nil
      expect(user.save).to be_falsey
    end
    it 'fails with a short password' do
      user.password = 'p'
      expect(user.save).to be_falsey
    end
    it 'succeeds with a valid password' do
      expect(user.save).to be_truthy
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:username) }
    it 'validates presence of :auth_token' do
      allow(user).to receive(:generate_auth_token)
      expect(user).to validate_presence_of(:auth_token)
    end
    it { is_expected.to ensure_length_of(:password).is_at_least(5) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to allow_value('james+test@snowball.is').for(:email) }
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

  describe '#generate_auth_token' do
    it 'generates a new auth token' do
      regex = '^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$'
      expect { user.save }.to change { user.auth_token }.from(nil).to(a_string_matching(regex))
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
