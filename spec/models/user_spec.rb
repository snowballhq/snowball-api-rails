require 'spec_helper'

describe User do
  subject(:user) { build :user }

  it { should be_valid }

  describe 'associations' do
    it { should have_many :clips }
    it { should have_many(:follows).dependent(:destroy) }
    it { should have_many(:followings).dependent(:destroy).class_name 'Follow' }
    it { should have_many(:identities).dependent(:destroy) }
    it { should have_many :participations }
    it { should have_many(:reels).through(:participations) }
  end

  describe 'validations' do
    it 'validates presence of :auth_token' do
      allow(user).to receive(:generate_auth_token)
      expect(user).to validate_presence_of :auth_token
    end
    it 'validates presence of :username' do
      allow(user).to receive(:generate_username)
      expect(user).to validate_presence_of :username
    end
    it 'validates uniqueness of :username' do
      user.save! # generates username
      expect(user).to validate_uniqueness_of :username
    end

    it { should_not allow_value('test@test').for :username }
    it { should_not allow_value('test test').for :username }
    it { should allow_value('username1').for :username }
    it { should validate_presence_of :name }
    it { should have_attached_file :avatar }
  end

  describe 'phony' do
    context 'when saving' do
      it 'normalizes the phone number' do
        user.phone_number = '4151234567'
        user.save!
        expect(user.phone_number).to eq '14151234567'
      end
      it 'validates the phone number is phony plausable' do
        user.phone_number = '123'
        expect do
          user.save
        end.to change(User, :count).by 0
      end
    end
  end

  describe 'before_validation on: :create' do
    describe '#generate_auth_token' do
      it 'generates a new authentication token' do
        expect(user.auth_token).to be_nil
        user.save!
        expect(user.auth_token).to_not be_nil
      end
    end
    describe '#generate_username' do
      it 'generates a new username' do
        expect(user.username).to be_nil
        user.save!
        expect(user.username).to eq user.email.split('@')[0].downcase.gsub(/[^0-9A-Za-z]/, '').truncate(30, omission: '')
      end
    end
  end

  describe 'facebook authentication' do
    before :each do
      user.save!
      @identity = build :identity, user: user
      @auth_hash = { provider: @identity.provider, uid: @identity.uid, name: user.name, email: user.email }
    end

    describe '.get_facebook_profile' do
      context 'with a valid access token' do
        it 'returns the facebook profile' do
          expect_any_instance_of(Koala::Facebook::API).to receive :get_object
          User.get_facebook_profile '1'
        end
      end
      context 'without a valid access token' do
        it 'returns nil' do
          allow_any_instance_of(Koala::Facebook::API).to receive(:get_object).and_return nil
          expect(User.get_facebook_profile '1').to be_nil
        end
      end
    end

    describe '.find_or_create_by_auth_hash' do
      context 'when identity is found' do
        it 'returns the user' do
          @identity.save!
          expect(User.find_or_create_by_auth_hash @auth_hash).to eq user
        end
      end
      context 'when identity is not found' do
        context 'when user is found' do
          it 'returns the user' do
            expect(User.find_or_create_by_auth_hash @auth_hash).to eq user
          end
        end
        context 'when user is not found' do
          it 'creates a new user' do
            user.destroy!
            expect do
              User.find_or_create_by_auth_hash @auth_hash
            end.to change(User, :count).by 1
          end
          it 'returns the user' do
            user.destroy!
            expect(User.find_or_create_by_auth_hash @auth_hash).to be_an_instance_of User
          end
        end
        it 'creates a new identity for the user' do
          expect do
            User.find_or_create_by_auth_hash @auth_hash
          end.to change(Identity, :count).by 1
        end
      end
    end
  end
  describe '#avatar_url' do
    context 'when an avatar exists' do
      it 'does not return the paperclip placeholder url' do
        expect(user.avatar_url).to_not eq '/avatars/original/missing.png'
      end
    end
    context 'when an avatar doesn\'t exist' do
      it 'returns null' do
        expect(user.avatar_url).to be_nil
      end
    end
  end

  describe '#following?(followable)' do
    before :each do
      user.save!
      @user2 = create :user
    end
    context 'when following the followable' do
      it 'returns true' do
        user.follows.create!(followable: @user2)
        expect(user.following?(@user2)).to be_true
      end
    end
    context 'when not following the follable' do
      it 'returns false' do
        expect(user.following?(@user2)).to be_false
      end
    end
  end
end
