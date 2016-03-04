require 'rails_helper'

RSpec.describe 'Devices', type: :request do
  describe 'POST /devices' do
    context 'with valid params' do
      it 'creates a device and registers it with amazon' do
        create(:user)
        params = { platform: 0, token: 'token', development: true }
        expect(Device.count).to eq(0)
        post '/v1/devices', params, authenticated_env
        expect(response).to have_http_status(202)
        expect(Device.count).to eq(1)
      end
    end
    context 'with invalid params' do
      it 'returns an error' do
        create(:user)
        post '/v1/devices', {}, authenticated_env
        expect(response).to have_http_status(400)
        expect(response.body).to eq({
          message: 'Token can\'t be blank'
        }.to_json)
      end
    end
  end
end
