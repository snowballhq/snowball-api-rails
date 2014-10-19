require 'rails_helper'

RSpec.describe 'Reels', type: :request do
  let(:user) { create(:user) }

  describe 'GET /reels' do
    it 'returns the current user\'s stream' do
      # TODO: add relationships spec
      reel = create(:reel) # , users: [user])
      # expect(user).to receive(:reels)
      get '/api/v1/reels'
      expect(response).to have_http_status(200)
      expect(response.body).to eq([
        {
          id: reel.id,
          title: reel.title
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
          title: reel.title
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
