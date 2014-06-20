require 'rails_helper'

describe Api::V1::RegistrationsController, type: :controller do
  let(:user) { build :user }
  let(:valid_attributes) { attributes_for(:user).stringify_keys! }

  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  describe 'with valid params' do
    before :each do
      @valid_request = proc { post :create, user: valid_attributes }
    end
    it 'creates a new user' do
      expect do
        @valid_request.call
      end.to change(User, :count).by 1
    end

    it 'assigns a newly created user as @user' do
      @valid_request.call
      expect(assigns(:user)).to be_a User
      expect(assigns(:user)).to be_persisted
    end

    it 'renders the correct template' do
      @valid_request.call
      expect(response).to render_template :create
    end
  end

  describe 'with invalid params' do
    before :each do
      @invalid_request = proc { post :create, user: { email: 'invalid' } }
    end
    it 'raises ActiveRecord::RecordInvalid' do
      bypass_rescue
      expect do
        @invalid_request.call
      end.to raise_error ActiveRecord::RecordInvalid
    end
  end
end
