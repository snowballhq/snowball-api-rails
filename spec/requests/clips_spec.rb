require 'rails_helper'

RSpec.describe 'Clips', type: :request do
  describe 'GET /clips/stream' do
    context 'with a user_id' do
      it 'returns the stream of clips created by the specified user' do
        clip = create(:clip)
        clip2 = create(:clip)
        get "/users/#{clip2.user.id}/clips/stream"
        expect(response).to have_http_status(200)
        expect(response.body).to eq([
          {
            id: clip2.id,
            video_url: clip2.video.url,
            thumbnail_url: clip2.thumbnail.url,
            user: {
              id: clip2.user.id,
              username: clip2.user.username,
              avatar_url: clip2.user.avatar.url,
              follower: clip2.user.following?(clip.user),
              following: clip.user.following?(clip2.user)
            },
            liked: false,
            created_at: clip2.user.created_at.to_time.to_i
          }
        ].to_json)
      end
    end
    context 'without a user_id' do
      it 'returns the stream of clips from users the current user is following' do
        user = create(:user)
        clip = create(:clip, user: user) # own clip should show in stream
        user2 = create(:user)
        clip2 = create(:clip, user: user2)
        user.follow(user2)
        create(:clip) # not following user, won't show in stream
        get '/clips/stream'
        expect(response).to have_http_status(200)
        expect(response.body).to eq([
          {
            id: clip.id,
            video_url: clip.video.url,
            thumbnail_url: clip.thumbnail.url,
            user: {
              id: user.id,
              username: user.username,
              avatar_url: user.avatar.url
            },
            liked: false,
            created_at: clip.created_at.to_time.to_i
          },
          {
            id: clip2.id,
            video_url: clip2.video.url,
            thumbnail_url: clip2.thumbnail.url,
            user: {
              id: user2.id,
              username: user2.username,
              avatar_url: user2.avatar.url,
              follower: user2.following?(user),
              following: user.following?(user2)
            },
            liked: false,
            created_at: clip2.created_at.to_time.to_i
          }
        ].to_json)
      end
    end
  end

  describe 'POST /clips' do
    context 'with valid params' do
      it 'creates and returns the clip' do
        create(:user)
        video = Rack::Test::UploadedFile.new(Rails.root + 'spec/support/video.mp4', 'video/mp4')
        thumbnail = Rack::Test::UploadedFile.new(Rails.root + 'spec/support/thumbnail.png', 'image/png')
        params = { video: video, thumbnail: thumbnail }
        post '/clips', params
        expect(response).to have_http_status(201)
        clip = Clip.last
        expect(response.body).to eq(
          {
            id: clip.id,
            video_url: clip.video.url,
            thumbnail_url: clip.thumbnail.url,
            user: {
              id: clip.user.id,
              username: clip.user.username,
              avatar_url: clip.user.avatar.url
            },
            liked: false,
            created_at: clip.created_at.to_time.to_i
          }.to_json)
      end
    end
    context 'with invalid params' do
      it 'returns an error' do
        create(:user) # current user
        post '/clips'
        expect(response).to have_http_status(400)
        expect(response.body).to eq({
          message: 'Video can\'t be blank'
        }.to_json)
      end
    end
  end

  describe 'DELETE /clips/:id' do
    context 'when user is clip owner' do
      it 'deletes the clip' do
        clip = create(:clip)
        delete "/clips/#{clip.id}"
        expect(response).to have_http_status(204)
        expect(Clip.count).to eq(0)
      end
    end
    context 'when user is not clip owner' do
      it 'does not delete the clip' do
        create(:user)
        clip = create(:clip)
        delete "/clips/#{clip.id}"
        expect(response).to have_http_status(403)
        expect(Clip.count).to eq(1)
      end
    end
  end
end