require 'rails_helper'

RSpec.describe Device, type: :model do
  subject(:device) { build(:device) }

  it { is_expected.to be_valid }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:arn) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
