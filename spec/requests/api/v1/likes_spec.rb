require 'rails_helper'

RSpec.describe 'Flags', type: :request do
  describe 'POST /clips/:clip_id/likes' do
    it 'likes the clip' do
      clip = create(:clip)
      post "/api/v1/clips/#{clip.id}/likes"
      expect(response).to have_http_status(201)
      expect(Like.count).to eq(1)
    end
  end
end
