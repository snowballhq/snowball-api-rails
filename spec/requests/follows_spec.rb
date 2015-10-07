require 'rails_helper'

RSpec.describe 'Follows', type: :request do
  describe 'GET /v1/users/:user_id/followers' do
    it 'returns the users who are following the specified user' do
      user = create(:user)
      user2 = create(:user)
      user2.follow(user)
      get "/v1/users/#{user.id}/followers", {}, authenticated_env
      expect(response).to have_http_status(200)
      expect(response.body).to eq([
        {
          id: user2.id,
          username: user2.username,
          avatar_url: user2.avatar.url,
          follower: true,
          following: false
        }
      ].to_json)
    end
  end

  describe 'GET /v1/users/:user_id/following' do
    it 'returns the users that the specified user is following' do
      user = create(:user)
      user2 = create(:user)
      user2.follow(user)
      get "/v1/users/#{user2.id}/following", {}, authenticated_env
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

  describe 'POST /v1/users/:user_id/follows' do
    it 'follows the user' do
      create(:user)
      user2 = create(:user)
      post "/v1/users/#{user2.id}/follow", {}, authenticated_env
      expect(response).to have_http_status(201)
      expect(Follow.count).to eq(1)
    end
  end

  describe 'DELETE /v1/users/:user_id/follows' do
    it 'unfollows the user' do
      user = create(:user)
      user2 = create(:user)
      user.follow(user2)
      delete "/v1/users/#{user2.id}/follow", {}, authenticated_env
      expect(response).to have_http_status(204)
      expect(Follow.count).to eq(0)
    end
  end
end
