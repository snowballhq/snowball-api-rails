require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /users/phone-search' do
    it 'returns users with specified phone numbers' do
      user = create(:user)
      user2 = create(:user, phone_number: '4151234567')
      # instead of user2.phone_number, we test normalization here
      params = { phone_numbers: [user.phone_number, '(415) 123-4567'] }
      post '/api/v1/users/phone-search', params
      expect(response).to have_http_status(200)
      expect(response.body).to eq([
        {
          id: user.id,
          username: user.username,
          avatar_url: user.avatar.url
        },
        {
          id: user2.id,
          username: user2.username,
          avatar_url: user2.avatar.url,
          follower: user2.following?(user),
          following: user.following?(user2)
        }
      ].to_json)
    end
    it 'does not return users with empty phone numbers' do
      create(:user, phone_number: '')
      params = { phone_numbers: [''] }
      post '/api/v1/users/phone-search', params
      expect(response).to have_http_status(200)
      expect(response.body).to eq([].to_json)
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
          avatar_url: user.avatar.url
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
          email: user.email,
          avatar_url: user.avatar.url,
          phone_number: user.phone_number
        }.to_json)
      end
    end
    context 'getting another user' do
      it 'returns the user without phone number with follow status' do
        user = create(:user)
        user2 = create(:user)
        get "/api/v1/users/#{user2.id}"
        expect(response).to have_http_status(200)
        expect(response.body).to eq({
          id: user2.id,
          username: user2.username,
          avatar_url: user2.avatar.url,
          follower: user2.following?(user),
          following: user.following?(user2)
        }.to_json)
      end
    end
  end

  describe 'PATCH /users/:id' do
    context 'with valid params' do
      it 'updates the user' do
        user = create(:user)
        user2 = build(:user)
        avatar = Rack::Test::UploadedFile.new(Rails.root + 'spec/support/thumbnail.png', 'image/png')
        params = { username: user2.username, password: user2.password, avatar: avatar }
        patch "/api/v1/users/#{user.id}", params
        expect(response).to have_http_status(204)
        expect(user.reload.username).to eq user2.username
        expect(user.reload.avatar.url).to_not be_nil
      end
    end
    context 'with invalid params' do
      it 'returns an error' do
        user = create(:user)
        params = { username: nil, password: 'password' }
        patch "/api/v1/users/#{user.id}", params
        expect(response).to have_http_status(400)
        expect(response.body).to eq({
          message: 'Username can\'t be blank'
        }.to_json)
      end
    end
  end

  describe 'POST /users/sign_in' do
    it 'returns an error when the email is invalid or doesn\'t exist' do
      params = { email: nil, password: nil }
      post '/api/v1/users/sign-in', params
      expect(response).to have_http_status(400)
      expect(response.body).to eq({
        message: 'Invalid email. Please try again.'
      }.to_json)
    end
    it 'returns an error when the password is invalid or doesn\'t match' do
      user = create(:user)
      params = { email: user.email, password: nil }
      post '/api/v1/users/sign-in', params
      expect(response).to have_http_status(400)
      expect(response.body).to eq({
        message: 'Invalid password. Please try again.'
      }.to_json)
    end
    context 'when everything is valid' do
      it 'returns the user' do
        user = create(:user)
        params = { email: user.email, password: user.password }
        post '/api/v1/users/sign-in', params
        expect(response).to have_http_status(200)
        expect(response.body).to eq({
          id: user.id,
          username: user.username,
          avatar_url: user.avatar.url,
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
    it 'returns an error when the email is invalid' do
      user = build(:user)
      params = { username: user.username, password: user.password, email: 'invalidemail@' }
      post '/api/v1/users/sign-up', params
      expect(response).to have_http_status(400)
      expect(response.body).to eq({
        message: 'Email is invalid'
      }.to_json)
    end
    context 'when everything is valid' do
      it 'returns the user' do
        user = build(:user)
        params = { username: user.username, password: user.password, email: user.email }
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
