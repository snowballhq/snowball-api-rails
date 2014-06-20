require 'spec_helper'

describe Identity, type: :model do
  subject(:identity) { build :identity }

  it { is_expected.to be_valid }

  describe 'associations' do
    it { is_expected.to belong_to :user }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :uid }
    it { is_expected.to validate_presence_of :provider }
    it { is_expected.to validate_presence_of :user }
  end

  describe 'authentication' do
    before :each do
      @auth_hash = { provider: identity.provider, uid: identity.uid }
    end

    describe '.find_by_auth_hash' do
      context 'when identity is found' do
        it 'returns the identity' do
          identity.save!
          expect(Identity.find_by_auth_hash @auth_hash).to eq identity
        end
      end
      context 'when identity is not found' do
        it 'returns nil' do
          expect(Identity.find_by_auth_hash @auth_hash).to eq nil
        end
      end
    end

    describe '.create_with_auth_hash' do
      it 'creates a new identity' do
        expect do
          identity.user.identities.create_with_auth_hash @auth_hash
        end.to change(Identity, :count).by 1
      end
    end
  end
end
