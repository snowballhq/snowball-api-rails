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
    it 'finds all users that have the provided contact information' do
      user.phone_number = '4151234567'
      user.save!
      post :find_by_contacts, contacts: [{ phone_number: user.phone_number }]
      expect(assigns :users).to eq [user]
    end
    it 'does not return users with null numbers' do
      post :find_by_contacts, contacts: [{ phone_number: nil }]
      expect(assigns :users).to eq []
    end
    it 'renders the correct template' do
      post :find_by_contacts, contacts: [{ phone_number: user.phone_number }]
      expect(response).to render_template :index
    end
  end
end
