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
end
