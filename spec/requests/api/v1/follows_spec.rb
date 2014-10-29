require 'rails_helper'

RSpec.describe 'Follows', type: :request do
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
