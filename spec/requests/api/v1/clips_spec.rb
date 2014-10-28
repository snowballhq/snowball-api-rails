require 'rails_helper'

RSpec.describe 'Clips', type: :request do
  describe 'GET /clips/feed' do
    # TODO: since_id
    it 'returns the feed of clips' do
      clip = create(:clip)
      clip2 = create(:clip)
      create(:clip) # not following user, won't show in feed
      user = create(:user)
      user.follows.create!(following: clip.user)
      user.follows.create!(following: clip2.user)
      get '/api/v1/clips/feed'
      expect(response).to have_http_status(200)
      expect(response.body).to eq([
        {
          id: clip.id,
          video_url: clip.video.url,
          user: {
            id: clip.user.id,
            username: clip.user.username,
            avatar_url: nil,
            you_follow: user.following?(clip.user)
          },
          created_at: clip.created_at.to_time.to_i
        },
        {
          id: clip2.id,
          video_url: clip2.video.url,
          user: {
            id: clip2.user.id,
            username: clip2.user.username,
            avatar_url: nil,
            you_follow: user.following?(clip2.user)
          },
          created_at: clip2.created_at.to_time.to_i
        }
      ].to_json)
    end
  end

  describe 'POST /clips' do
    context 'with valid params' do
      it 'creates and returns the clip' do
        create(:user)
        video = Rack::Test::UploadedFile.new(Rails.root + 'spec/support/video.mp4', 'video/mp4')
        params = { video: video }
        post '/api/v1/clips', params
        expect(response).to have_http_status(201)
        clip = Clip.last
        expect(response.body).to eq(
        {
          id: clip.id,
          video_url: clip.video.url,
          user: {
            id: clip.user.id,
            username: clip.user.username,
            avatar_url: nil
          },
          created_at: clip.created_at.to_time.to_i
        }.to_json)
      end
    end
    context 'with invalid params' do
      it 'returns an error' do
        create(:user) # current user
        post '/api/v1/clips'
        expect(response).to have_http_status(400)
        expect(response.body).to eq({
          message: 'Video can\'t be blank'
        }.to_json)
      end
    end
  end
end
