require 'rails_helper'

RSpec.describe 'Reels', type: :request do
  let(:user) { create(:user) }

  describe 'GET /reels' do
    it 'returns the current user\'s stream' do
      participation = create(:participation, user: user)
      get '/api/v1/reels'
      expect(response).to have_http_status(200)
      expect(response.body).to eq([
        {
          id: participation.reel.id,
          title: participation.reel.title,
          users_title: participation.reel.users_title
          # TODO: send next clip to client
          # next_clip: {
          #   id: clip.id,
          #   reel_id: participation.reel.id,
          #   video_url: clip.video.url,
          #   user: {
          #     id: clip.user.id,
          #     name: clip.user.name,
          #     avatar_url: nil
          #   },
          #   created_at: clip.created_at.to_time.to_i
          # }
        }
      ].to_json)
    end
  end

  describe 'POST /reels' do
    context 'with valid params' do
      it 'creates and returns the reel' do
        reel = build(:reel)
        params = { title: reel.title }
        post '/api/v1/reels', params
        expect(response).to have_http_status(201)
        reel = Reel.last
        expect(response.body).to eq(
        {
          id: reel.id,
          title: reel.title,
          users_title: reel.users_title
        }.to_json)
      end
    end
    context 'with invalid params' do
      # This is not specced since there are no validations on reel
    end
  end

  describe 'PATCH /reels/:id' do
    context 'with valid params' do
      it 'updates the reel' do
        reel = create(:reel)
        title = build(:reel).title
        params = { title: title }
        patch "/api/v1/reels/#{reel.id}", params
        expect(response).to have_http_status(204)
        expect(reel.reload.title).to eq(title)
      end
    end
    context 'with invalid params' do
      # This is not specced since there are no validations on reel
    end
  end
end
