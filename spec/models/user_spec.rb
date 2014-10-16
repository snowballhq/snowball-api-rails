require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  it { should be_valid }

  describe 'validations' do
    it { should validate_presence_of(:phone_number) }
    it 'validates presence of :auth_token' do
      allow(user).to receive(:generate_and_set_auth_token)
      expect(user).to validate_presence_of(:auth_token)
    end
  end

  describe 'before_validation(on: :create)' do
    it 'generates and sets a new auth token' do
      expect { user.save }.to change { user.auth_token }.from(nil).to(a_string_matching(/[0-9a-f]{32}/))
    end
  end
end
