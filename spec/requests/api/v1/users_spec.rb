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
          name: user.name
        },
        {
          id: user2.id,
          name: user2.name
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
        name: user.name
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
    it 'sends the user a text message with a verification code'
    context 'when the user exists' do
      it 'returns the user' do
        user = create(:user)
        params = { phone_number: user.phone_number }
        post '/api/v1/users/phone-auth', params
        expect(response).to have_http_status(200)
        expect(response.body).to eq({
          id: user.id,
          name: user.name
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
          name: user.name
        }.to_json)
      end
    end
  end
end
