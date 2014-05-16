require 'spec_helper'

describe Api::V1::SessionsController do

  let(:user) { build :user }

  describe 'POST create' do
    context 'email provider' do
      before :each do
        user.save!
      end
      describe 'with valid params' do
        before :each do
          valid_attributes = { email: user.email, password: user.password }
          @valid_request = proc { post :create, user: valid_attributes, format: :json }
        end

        it 'assigns the logged in user as @user' do
          @valid_request.call
          assigns(:user).should eq user
        end

        it 'renders the correct template' do
          @valid_request.call
          expect(response).to render_template :create
        end
      end
      describe 'with invalid params' do
        before :each do
          invalid_attributes = { email: 'notanemail', password: user.password }
          @invalid_request = proc { post :create, user: invalid_attributes, format: :json }
        end
        context 'with invalid email' do
          it 'raises an error' do
            expect do
              invalid_attributes = { email: 'notanemail', password: user.password }
              bypass_rescue
              post :create, user: invalid_attributes, format: :json
            end.to raise_error
          end
        end
        context 'with invalid password' do
          it 'raises an error' do
            expect do
              invalid_attributes = { email: user.email, password: 'notapassword' }
              bypass_rescue
              post :create, user: invalid_attributes, format: :json
            end.to raise_error
          end
        end
      end
    end

#     context 'facebook provider' do
#       describe 'with valid params' do
#         before :each do
#           profile = { id: '1238783003', name: user.name, email: user.email }
#           User.stub(:get_facebook_profile).and_return profile
#           @valid_request = proc { post :create,  provider: :facebook, access_token: '12345', format: :json }
#         end
#
#         it 'gets the Facebook profile' do
#           User.stub(:find_or_create_by_auth_hash).and_return(create: user)
#           expect(User).to receive :get_facebook_profile
#           @valid_request.call
#         end
#
#         context 'when the Facebook profile exists' do
#           it 'finds or creates a user' do
#             expect(User).to receive :find_or_create_by_auth_hash
#             @valid_request.call
#           end
#           it 'renders the correct template' do
#             User.stub(:find_or_create_by_auth_hash).and_return(create: user)
#             @valid_request.call
#             expect(response).to render_template :create
#           end
#         end
#
#         context 'when there is a problem getting the Facebook profile' do
#           it 'returns an error in json' do
#             User.stub(:get_facebook_profile).and_return nil
#             json = "{\"type\":\"api_error\",\"message\":\"Internal server error.\"}"
#             @valid_request.call
#             expect(response.body).to eq json
#           end
#         end
#       end
#       describe 'with invalid params' do
#         it 'raises an error' do
#           expect do
#             bypass_rescue
#             @valid_request[:access_token] = nil
#             @valid_request.call
#           end.to raise_error
#         end
#       end
#     end
  end
end