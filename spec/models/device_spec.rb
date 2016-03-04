require 'rails_helper'

RSpec.describe Device, type: :model do
  subject(:device) { build(:device) }

  it { is_expected.to be_valid }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    # it { is_expected.to validate_inclusion_of(:development).in_array([true, false]) }
    it { is_expected.to validate_inclusion_of(:platform).in_array([0]) }
    it { is_expected.to validate_presence_of(:token) }
    it 'validates the token as unique and case sensitive' do
      device.save!
      device2 = build(:device, token: device.token.upcase)
      expect(device2.valid?).to be_falsey
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'before_save' do
    it 'calls clean_token' do
      expect(device).to receive(:clean_token)
      device.save
    end
  end

  describe '#clean_token' do
    it 'strips spaces from the token' do
      device.token = 'test test test test test'
      device.save
      expect(device.token).to eq('testtesttesttesttest')
    end
  end
end
