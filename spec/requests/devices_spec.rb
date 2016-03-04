require 'rails_helper'

RSpec.describe 'Devices', type: :request do
  describe 'POST /devices' do
    context 'with valid params' do
      it 'creates a device and registers it with amazon' do
        # stub_request(:any, /.*/).to_return(
        #   body: '<CreatePlatformEndpointResponse xmlns=\"http://sns.amazonaws.com/doc/2010-03-31/\">\n  <CreatePlatformEndpointResult>\n    <EndpointArn>arn:aws:sns:us-west-2:235811926729:endpoint/APNS_SANDBOX/snowball-ios-development/3a7d6145-2184-342b-abb3-52dc8e055668</EndpointArn>\n  </CreatePlatformEndpointResult>\n  <ResponseMetadata>\n    <RequestId>561097cf-3cf6-58c1-bd10-d89cf9271e2e</RequestId>\n  </ResponseMetadata>\n</CreatePlatformEndpointResponse>\n'
        # )
        create(:user)
        params = { platform: 0, token: 'token' }
        expect(Device.count).to eq(0)
        post '/v1/devices', params, authenticated_env
        expect(response).to have_http_status(202)
        # expect(Device.count).to eq(1)
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
