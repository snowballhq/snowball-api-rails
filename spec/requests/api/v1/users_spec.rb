require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users?phone_number=' do
    it 'returns users with specified phone number(s)' do
      user = create(:user)
      user2 = create(:user)
      get "/api/v1/users?phone_number=#{user.phone_number},#{user2.phone_number}"
      expect(response).to have_http_status(200)
      expect(response.body).to eq([
        {
          id: user.id,
          name: user.name,
          avatar_url: nil
        },
        {
          id: user2.id,
          name: user2.name,
          avatar_url: nil
        }
      ].to_json)
    end
  end

  describe 'GET /users/:id' do
    it 'returns the user' do
      user = create(:user)
      get "/api/v1/users/#{user.id}"
      expect(response).to have_http_status(200)
      expect(response.body).to eq({
        id: user.id,
        name: user.name,
        avatar_url: nil
      }.to_json)
    end
  end

  describe 'PATCH /users/:id' do
    it 'updates the user' do
      user = create(:user)
      name = 'John Doe'
      params = { name: name }
      patch "/api/v1/users/#{user.id}", params
      expect(response).to have_http_status(204)
      expect(user.reload.name).to eq name
    end
  end

  describe 'POST /users/phone-authentication' do
    context 'with a valid phone number' do
      it 'sends the user a text message with a new verification code'
      context 'when the user exists' do
        it 'returns the user' do
          user = create(:user)
          params = { phone_number: user.phone_number }
          post '/api/v1/users/phone-auth', params
          expect(response).to have_http_status(200)
          expect(response.body).to eq({
            id: user.id,
            name: user.name,
            avatar_url: nil
          }.to_json)
        end
      end
      context 'when the user does not exist' do
        it 'creates and returns the user' do
          user = build(:user)
          params = { phone_number: user.phone_number }
          post '/api/v1/users/phone-auth', params
          expect(response).to have_http_status(201)
          user = User.last
          expect(response.body).to eq({
            id: user.id,
            name: user.name,
            avatar_url: nil
          }.to_json)
        end
      end
    end
    context 'with an invalid phone number'
  end

  describe 'POST /users/:user_id/phone_verification' do
    context 'when the code is valid' do
      it 'clears the verification code' do
        user = create(:user, phone_number_verification_code: '1234')
        verification_code = user.phone_number_verification_code
        params = { phone_number_verification_code: verification_code }
        post "/api/v1/users/#{user.id}/phone-verification", params
        expect(user.reload.phone_number_verification_code).to_not eq(verification_code)
      end
      it 'generates a new auth token' do
        user = create(:user, phone_number_verification_code: '1234')
        auth_token = user.auth_token
        params = { phone_number_verification_code: user.phone_number_verification_code }
        post "/api/v1/users/#{user.id}/phone-verification", params
        expect(user.reload.auth_token).to_not eq(auth_token)
      end
      it 'returns the user' do
        user = create(:user, phone_number_verification_code: '1234')
        params = { phone_number_verification_code: user.phone_number_verification_code }
        post "/api/v1/users/#{user.id}/phone-verification", params
        expect(response).to have_http_status(200)
        expect(response.body).to eq({
          id: user.id,
          name: user.name,
          avatar_url: nil,
          auth_token: user.reload.auth_token
        }.to_json)
      end
    end
    context 'when the code is invalid'
  end
end
