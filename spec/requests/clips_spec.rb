require 'rails_helper'

RSpec.describe 'Clips', type: :request do
  describe 'GET /reels/:reel_id/clips' do
    # TODO: since_id
    it 'returns clips for the specified reel' do
      reel = create(:reel)
      clip = create(:clip, reel: reel)
      clip2 = create(:clip, reel: reel)
      get "/api/v1/reels/#{reel.id}/clips"
      expect(response).to have_http_status(200)
      expect(response.body).to eq([
        {
          id: clip.id,
          reel_id: reel.id,
          video_url: clip.video.url,
          user: {
            id: clip.user.id,
            name: clip.user.name,
            avatar_url: nil
          },
          created_at: clip.created_at.to_time.to_i
        },
        {
          id: clip2.id,
          reel_id: reel.id,
          video_url: clip2.video.url,
          user: {
            id: clip2.user.id,
            name: clip2.user.name,
            avatar_url: nil
          },
          created_at: clip2.created_at.to_time.to_i
        }
      ].to_json)
    end
  end

  describe 'POST /reels/:reel_id/clips' do
    context 'with valid params' do
      it 'creates and returns the clip' do
        clip = build(:clip)
        video = Rack::Test::UploadedFile.new(Rails.root + 'spec/support/video.mp4', 'video/mp4')
        params = { video: video }
        p params
        post "/api/v1/reels/#{clip.reel.id}/clips", params
        p response
        expect(response).to have_http_status(201)
        clip = Clip.last
        expect(response.body).to eq(
        {
          id: clip.id,
          reel_id: clip.reel.id,
          video_url: clip.video.url,
          user: {
            id: clip.user.id,
            name: clip.user.name,
            avatar_url: nil
          },
          created_at: clip.created_at.to_time.to_i
        }.to_json)
      end
    end
    context 'with invalid params' do
      it 'returns an error' do
        create(:user) # current user
        reel = create(:reel)
        post "/api/v1/reels/#{reel.id}/clips"
        expect(response).to have_http_status(400)
        expect(response.body).to eq({
          message: 'Video can\'t be blank'
        }.to_json)
      end
    end
  end
end
