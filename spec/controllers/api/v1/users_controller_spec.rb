require 'spec_helper'
require 'controllers/shared_controller_behaviors'

describe Api::V1::UsersController do
  let(:user) { create :user }
  let(:valid_attributes) { attributes_for(:user).stringify_keys! }

  before :each do
    login_api user.auth_token
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  it_behaves_like 'a restricted api controller' do
    let(:action) do
      proc do
        get :show, id: user
      end
    end
  end

  describe 'GET show' do
    it 'assigns the requested user as @user' do
      get :show, id: user
      assigns(:user).should eq user
    end
  end

#   describe 'PUT update' do
#     before :each do
#       user.save!
#     end
#     describe 'with valid params' do
#       it 'updates the requested user' do
#         expected_attributes = valid_attributes.extract!('name', 'username', 'email')
#         expect_any_instance_of(User).to receive(:update!).with expected_attributes
#         put :update, id: user, user: expected_attributes
#       end
#
#       it 'assigns the requested user as @user' do
#         put :update, id: user, user: valid_attributes
#         expect(assigns :user).to eq user
#       end
#
#       it 'renders the correct template' do
#         put :update, id: user, user: valid_attributes
#         expect(response).to render_template :update
#       end
#     end
#
#     describe 'with invalid params' do
#       it 'raises an error' do
#         expect do
#           bypass_rescue
#           put :update, id: user, user: {}
#         end.to raise_error
#       end
#     end
#   end
end
