require 'rails_helper'

RSpec.describe 'Participations', type: :request do
  describe 'GET /reels/:reel_id/participations' do
    it 'returns participations for the specified reel' do
      reel = create(:reel)
      participation = create(:participation, reel: reel)
      participation2 = create(:participation, reel: reel)
      get "/api/v1/reels/#{reel.id}/participations"
      expect(response).to have_http_status(200)
      expect(response.body).to eq([
        {
          id: participation.id,
          user: {
            id: participation.user.id,
            name: participation.user.name,
            avatar_url: nil
          }
        },
        {
          id: participation2.id,
          user: {
            id: participation2.user.id,
            name: participation2.user.name,
            avatar_url: nil
          }
        }
      ].to_json)
    end
  end

  describe 'POST /reels/:reel_id/participations' do
    context 'with valid params' do
      it 'creates and returns the participation' do
        participation = build(:participation)
        params = { user_id: participation.user.id }
        post "/api/v1/reels/#{participation.reel.id}/participations", params
        expect(response).to have_http_status(201)
        participation = Participation.last
        expect(response.body).to eq(
        {
          id: participation.id,
          user: {
            id: participation.user.id,
            name: participation.user.name,
            avatar_url: nil
          }
        }.to_json)
      end
    end
    context 'with invalid params' do
      it 'returns an error' do
        reel = create(:reel)
        post "/api/v1/reels/#{reel.id}/participations"
        expect(response).to have_http_status(400)
        expect(response.body).to eq({
          message: 'User can\'t be blank'
        }.to_json)
      end
    end
  end
end
