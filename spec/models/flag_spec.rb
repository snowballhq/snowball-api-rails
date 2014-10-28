require 'rails_helper'

RSpec.describe Flag, type: :model do
  subject(:flag) { build(:flag) }

  it { is_expected.to be_valid }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:clip) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:clip) }
  end
end
