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
          reel_id: reel.id,
          user: {
            id: participation.user.id,
            name: participation.user.name,
            avatar_url: nil
          }
        },
        {
          id: participation2.id,
          reel_id: reel.id,
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
          reel_id: participation.reel.id,
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

  describe 'PATCH /participations/:id' do
    context 'with valid params' do
      it 'updates the participation' do
        participation = create(:participation)
        # TODO: use clip instead of random generated uuid for this
        last_watched_clip_id = SecureRandom.uuid
        params = { last_watched_clip_id: last_watched_clip_id }
        patch "/api/v1/participations/#{participation.id}", params
        expect(response).to have_http_status(204)
        expect(participation.reload.last_watched_clip_id).to eq last_watched_clip_id
      end
    end
    context 'with invalid params' do
      it 'returns an error' do
        participation = create(:participation)
        params = { reel_id: nil }
        patch "/api/v1/participations/#{participation.id}", params
        expect(response).to have_http_status(400)
        expect(response.body).to eq({
          message: 'Reel can\'t be blank'
        }.to_json)
      end
    end
  end

  describe 'DELETE /participations/:id' do
    it 'destroys the participation' do
      participation = create(:participation)
      delete "/api/v1/participations/#{participation.id}"
      expect(response).to have_http_status(204)
      expect(Participation.count).to eq(0)
    end
  end
end
