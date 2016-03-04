require 'rails_helper'

RSpec.describe 'Devices', type: :request do
  describe 'POST /devices' do
    context 'with valid params' do
      it 'registers the device with amazon' do
        create(:user)
        params = { type: 0, token: 'token', development: true }
        post '/v1/devices', params, authenticated_env
        expect(response).to have_http_status(202)
      end
    end
    context 'with invalid params' do
      it 'returns an error' do
        create(:user)
        post '/v1/devices', {}, authenticated_env
        expect(response).to have_http_status(400)
        expect(response.body).to eq({
          message: 'Type can\'t be blank'
        }.to_json)
      end
    end
  end
end
