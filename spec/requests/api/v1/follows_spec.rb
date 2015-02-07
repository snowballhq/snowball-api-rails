require 'rails_helper'

RSpec.describe 'Follows', type: :request do
  describe 'GET /users/:user_id/followers' do
    it 'returns the users who are following the specified user' do
      user = create(:user)
      user2 = create(:user)
      create(:follow, following: user2, follower: user)
      get "/api/v1/users/#{user2.id}/followers"
      expect(response).to have_http_status(200)
      expect(response.body).to eq([
        {
          id: user.id,
          username: user.username,
          avatar_url: nil,
          follower: true,
          following: false
        }
      ].to_json)
    end
  end

  describe 'GET /users/:user_id/following' do
    it 'returns the users that the specified user is following' do
      user = create(:user)
      user2 = create(:user)
      create(:follow, following: user, follower: user2)
      get "/api/v1/users/#{user2.id}/following"
      expect(response).to have_http_status(200)
      expect(response.body).to eq([
        {
          id: user.id,
          username: user.username,
          avatar_url: nil,
          follower: false,
          following: true
        }
      ].to_json)
    end
  end

  describe 'POST /users/:user_id/follows' do
    it 'follows the user' do
      user = create(:user)
      create(:user)
      post "/api/v1/users/#{user.id}/follow"
      expect(response).to have_http_status(201)
      expect(Follow.count).to eq(1)
    end
  end

  describe 'DELETE /users/:user_id/follows' do
    it 'unfollows the user' do
      user = create(:user)
      user2 = create(:user)
      create(:follow, following: user, follower: user2)
      delete "/api/v1/users/#{user.id}/follow"
      expect(response).to have_http_status(204)
      expect(Follow.count).to eq(0)
    end
  end
end
