require 'rails_helper'
require 'controllers/shared_controller_behaviors'

describe Api::V1::UsersController, type: :controller do
  let(:user) { create :user }
  let(:valid_attributes) { attributes_for(:user).stringify_keys! }

  before :each do
    login_api user.auth_token
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  it_behaves_like 'a restricted api controller' do
    let(:action) do
      proc do
        get :show, id: 'me'
      end
    end
  end

  describe 'GET show' do
    it 'assigns the requested user as @user' do
      get :show, id: 'me'
      expect(assigns(:user)).to eq user
    end
  end

  describe 'PUT update' do
    before :each do
      user.save!
    end
    describe 'with valid params' do
      it 'updates the requested user' do
        expected_attributes = valid_attributes.extract!('name', 'username', 'email')
        expect_any_instance_of(User).to receive(:update!).with expected_attributes
        put :update, id: 'me', user: expected_attributes
      end

      it 'declines the phone number parameter' do
        phone_number = '14151234567'
        valid_attributes[:phone_number] = phone_number
        put :update, id: 'me', user: valid_attributes
        expect(user.reload.phone_number).to be_nil
      end

      it 'assigns the requested user as @user' do
        put :update, id: 'me', user: valid_attributes
        expect(assigns :user).to eq user
      end

      it 'renders the correct template' do
        put :update, id: 'me', user: valid_attributes
        expect(response).to render_template :show
      end
    end

    describe 'with invalid params' do
      it 'raises an error' do
        expect do
          bypass_rescue
          put :update, id: 'me', user: {}
        end.to raise_error
      end
    end
  end

  describe 'POST find_by_contacts' do
    it 'finds all users that have the provided contact information that is verified' do
      user.phone_number = '4151234567'
      user.phone_number_verified = true
      user.save!
      post :find_by_contacts, contacts: [{ phone_number: user.phone_number }]
      expect(assigns :users).to eq [user]
    end
    it 'does not return users with null numbers' do
      post :find_by_contacts, contacts: [{ phone_number: nil }]
      expect(assigns :users).to eq []
    end
    it 'does not return users with unverified numbers' do
      user.phone_number = '4151234567'
      user.save!
      post :find_by_contacts, contacts: [{ phone_number: user.phone_number }]
      expect(assigns :users).to eq []
    end
    it 'renders the correct template' do
      post :find_by_contacts, contacts: [{ phone_number: user.phone_number }]
      expect(response).to render_template :index
    end
  end

  describe 'POST phone_number_change' do
    before :each do
      user.phone_number = '4151234567'
      user.save!
      @new_phone_number = '14157654321'
    end
    describe 'with a valid phone number' do
      it 'changes the users phone number' do
        post :phone_number_change, 'me', user: { phone_number: @new_phone_number }
        expect(user.reload.phone_number).to eq @new_phone_number
      end
      it 'creates a phone number verification code of length 4 numbers' do
        expect(user.phone_number_verification_code).to be_nil
        post :phone_number_change, 'me', user: { phone_number: @new_phone_number }
        expect(user.reload.phone_number_verification_code.length).to eq 4
      end
      it 'sets the phone number verified flag to false' do
        user.phone_number_verified = true
        user.save!
        expect(user.phone_number_verified).to be_truthy
        post :phone_number_change, 'me', user: { phone_number: @new_phone_number }
        expect(user.reload.phone_number_verified).to be_falsey
      end
      it 'sends the user a verification text message' do
        # TODO: This should be tested
      end
      it 'renders the correct template' do
        post :phone_number_change, 'me', user: { phone_number: @new_phone_number }
        expect(response).to render_template :show
      end
    end
    describe 'with an invalid phone number' do
      it 'raises an error' do
        expect do
          bypass_rescue
          post :phone_number_change, 'me', user: { phone_number: '1' }
        end.to raise_error
      end
    end
  end

  describe 'POST phone_number_verification' do
    before :each do
      user.phone_number = '4151234567'
      user.phone_number_verification_code = '1234'
      user.save!
    end
    describe 'with a valid verification code' do
      it 'sets the phone number verified flag to true' do
        expect(user.phone_number_verified).to be_falsey
        post :phone_number_verification, 'me', user: { phone_number_verification_code: user.phone_number_verification_code }
        expect(user.reload.phone_number_verified).to be_truthy
      end
      it 'removes the phone number verification code' do
        expect(user.phone_number_verification_code).to eq(user.phone_number_verification_code)
        post :phone_number_verification, 'me', user: { phone_number_verification_code: user.phone_number_verification_code }
        expect(user.reload.phone_number_verification_code).to be_nil
      end
      it 'renders the correct template' do
        post :phone_number_verification, 'me', user: { phone_number_verification_code: user.phone_number_verification_code }
        expect(response).to render_template :show
      end
    end
    describe 'with an invalid verification code' do
      it 'raises Snowball::InvalidPhoneNumberVerificationCode' do
        expect do
          bypass_rescue
          post :phone_number_verification, 'me', user: { phone_number_verification_code: '9999' }
        end.to raise_error Snowball::InvalidPhoneNumberVerificationCode
      end
    end
  end
end
