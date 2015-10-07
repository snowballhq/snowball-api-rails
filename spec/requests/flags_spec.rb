require 'rails_helper'

RSpec.describe 'Flags', type: :request do
  describe 'POST /clips/:clip_id/flags' do
    it 'flags the clip' do
      clip = create(:clip)
      post "/v1/clips/#{clip.id}/flags"
      expect(response).to have_http_status(201)
      expect(Flag.count).to eq(1)
    end
  end
end
