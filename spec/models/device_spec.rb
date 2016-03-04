require 'rails_helper'

RSpec.describe Device, type: :model do
  subject(:device) { build(:device) }

  it { is_expected.to be_valid }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    # it { is_expected.to validate_inclusion_of(:development).in_array([true, false]) }
    it { is_expected.to validate_inclusion_of(:type).in_array([0]) }
    it { is_expected.to validate_presence_of(:token) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
