require 'spec_helper'

describe User do
  subject(:user) { build :user }

  it { should be_valid }

  describe 'associations' do
    it { should have_many :clips }
    it { should have_many(:liked).class_name 'Like' }
    it { should have_many(:likes).through :clips }
    it { should have_many(:identities).dependent(:destroy) }
  end

  describe 'validations' do
    it 'validates presence of :auth_token' do
      user.stub(:generate_auth_token)
      user.should validate_presence_of :auth_token
    end
    it 'validates presence of :username' do
      user.stub(:generate_username)
      user.should validate_presence_of :username
    end
    it 'validates uniqueness of :username' do
      user.save! # generates username
      user.should validate_uniqueness_of :username
    end

    it { should_not allow_value('test@test').for :username }
    it { should_not allow_value('test test').for :username }
    it { should allow_value('username1').for :username }
    it { should validate_presence_of :name }
    it { should have_attached_file :avatar }
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
          Koala::Facebook::API.any_instance.should_receive :get_object
          User.get_facebook_profile '1'
        end
      end
      context 'without a valid access token' do
        it 'returns nil' do
          Koala::Facebook::API.any_instance.stub(:get_object).and_return nil
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
end
