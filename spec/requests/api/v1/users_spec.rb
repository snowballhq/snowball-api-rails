require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users?phone_number=' do
    it 'returns users with specified phone number(s)' do
      user = create(:user)
      get "/api/v1/users?phone_number=#{user.phone_number}"
      expect(response).to have_http_status(200)
      expect(response.body).to eq([
        {
          id: user.id,
          name: user.name,
          phone_number: user.phone_number
        }
      ].to_json)
    end
  end
end
