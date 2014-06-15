require 'spec_helper'

describe Reel do
  subject(:reel) { build :reel }

  it { should be_valid }

  describe 'associations' do
    it { should have_many :clips }
    it { should have_many :participations }
    it { should have_many(:participants).through(:participations).source(:user) }
  end
end
