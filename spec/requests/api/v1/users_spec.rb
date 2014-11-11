require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users?phone_number=' do
    it 'returns users with specified phone number(s)' do
      user = create(:user)
      user2 = create(:user, phone_number: '4151234567')
      # instead of user2.phone_number, we test normalization here
      query = { phone_number: "#{user.phone_number}, +1 (415) 123-4567" }.to_query
      get "/api/v1/users?#{query}"
      expect(response).to have_http_status(200)
      expect(response.body).to eq([
        {
          id: user.id,
          username: user.username,
          avatar_url: nil,
          you_follow: user2.following?(user)
        },
        {
          id: user2.id,
          username: user2.username,
          avatar_url: nil
        }
      ].to_json)
    end
  end

  describe 'GET /users?username=' do
    it 'returns users with specified username' do
      user = create(:user, username: 'user')
      get "/api/v1/users?username=#{user.username}"
      expect(response).to have_http_status(200)
      expect(response.body).to eq([
        {
          id: user.id,
          username: user.username,
          avatar_url: nil
        }
      ].to_json)
    end
  end

  describe 'GET /users/:id' do
    context 'getting current user' do
      it 'returns the user with phone number without follow status' do
        user = create(:user)
        get "/api/v1/users/#{user.id}"
        expect(response).to have_http_status(200)
        expect(response.body).to eq({
          id: user.id,
          username: user.username,
          avatar_url: nil,
          phone_number: user.phone_number
        }.to_json)
      end
    end
    context 'getting another user' do
      it 'returns the user without phone number with follow status' do
        user = create(:user)
        user2 = create(:user)
        get "/api/v1/users/#{user.id}"
        expect(response).to have_http_status(200)
        expect(response.body).to eq({
          id: user.id,
          username: user.username,
          avatar_url: nil,
          you_follow: user2.following?(user)
        }.to_json)
      end
    end
  end

  describe 'PATCH /users/:id' do
    context 'with valid params' do
      it 'updates the user' do
        user = create(:user)
        username = build(:user).username
        params = { username: username }
        patch "/api/v1/users/#{user.id}", params
        expect(response).to have_http_status(204)
        expect(user.reload.username).to eq username
      end
    end
    context 'with invalid params' do
      it 'returns an error' do
        post '/api/v1/users/phone-auth'
        expect(response).to have_http_status(400)
        expect(response.body).to eq({
          message: 'Phone number can\'t be blank'
        }.to_json)
      end
    end
  end

  describe 'POST /users/phone-auth' do
    context 'with a valid phone number' do
      it 'sends the user a text message with a new verification code' do
        user = create(:user)
        params = { phone_number: user.phone_number }
        expect_any_instance_of(User).to receive(:send_verification_text)
        post '/api/v1/users/phone-auth', params
      end
      context 'when the user exists' do
        it 'returns the user' do
          user = create(:user)
          params = { phone_number: user.phone_number }
          post '/api/v1/users/phone-auth', params
          expect(response).to have_http_status(200)
          expect(response.body).to eq({
            id: user.id,
            username: user.username,
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
            username: user.username,
            avatar_url: nil
          }.to_json)
        end
      end
    end
    context 'with an invalid phone number' do
      it 'returns an error' do
        params = { phone_number: '123' }
        post '/api/v1/users/phone-auth', params
        expect(response).to have_http_status(400)
        expect(response.body).to eq({
          message: 'Phone number is an invalid number'
        }.to_json)
      end
    end
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
          username: user.username,
          avatar_url: nil,
          auth_token: user.reload.auth_token
        }.to_json)
      end
    end
    context 'when the code is invalid' do
      it 'returns an error' do
        user = create(:user, phone_number_verification_code: '1234')
        params = { phone_number_verification_code: '1235' }
        post "/api/v1/users/#{user.id}/phone-verification", params
        expect(response).to have_http_status(400)
        expect(response.body).to eq({
          message: 'Looks like you typed in incorrect numbers. Please try again.'
        }.to_json)
      end
    end
  end

  describe 'POST /users/sign_in' do
    it 'returns an error when the username is invalid or doesn\'t exist' do
      params = { username: nil, password: nil }
      post '/api/v1/users/sign-in', params
      expect(response).to have_http_status(400)
      expect(response.body).to eq({
        message: 'Invalid username. Please try again.'
      }.to_json)
    end
    it 'returns an error when the password is invalid or doesn\'t match' do
      user = create(:user)
      params = { username: user.username, password: nil }
      post '/api/v1/users/sign-in', params
      expect(response).to have_http_status(400)
      expect(response.body).to eq({
        message: 'Invalid password. Please try again.'
      }.to_json)
    end
    context 'when everything is valid' do
      it 'returns the user' do
        user = create(:user)
        params = { username: user.username, password: user.password }
        post '/api/v1/users/sign-in', params
        expect(response).to have_http_status(200)
        expect(response.body).to eq({
          id: user.id,
          username: user.username,
          avatar_url: nil,
          auth_token: user.reload.auth_token
        }.to_json)
      end
    end
  end

  describe 'POST /users/sign_up' do
    it 'returns an error when the username is invalid' do
      params = { username: nil, password: nil }
      post '/api/v1/users/sign-up', params
      expect(response).to have_http_status(400)
      expect(response.body).to eq({
        message: 'Invalid username. Please try again.'
      }.to_json)
    end
    it 'returns an error when the username is already in use' do
      user = create(:user)
      params = { username: user.username, password: user.password }
      post '/api/v1/users/sign-up', params
      expect(response).to have_http_status(400)
      expect(response.body).to eq({
        message: 'Username is already in use. Please select another or try to sign in.'
      }.to_json)
    end
    it 'returns an error when the password is invalid' do
      user = build(:user)
      params = { username: user.username, password: nil }
      post '/api/v1/users/sign-up', params
      expect(response).to have_http_status(400)
      expect(response.body).to eq({
        message: 'Invalid password. Please try again.'
      }.to_json)
    end
    context 'when everything is valid' do
      it 'returns the user' do
        user = build(:user)
        params = { username: user.username, password: user.password }
        post '/api/v1/users/sign-up', params
        expect(response).to have_http_status(200)
        user = User.where(username: user.username).first
        expect(response.body).to eq({
          id: user.id,
          username: user.username,
          avatar_url: nil,
          auth_token: user.auth_token
        }.to_json)
      end
    end
  end
end
