require 'rails_helper'

RSpec.describe Reel, type: :model do
  subject(:reel) { build(:reel) }

  it { is_expected.to be_valid }

  describe 'associations' do
    it { is_expected.to have_many(:participations) }
    it { is_expected.to have_many(:users).through(:participations) }
  end
end
