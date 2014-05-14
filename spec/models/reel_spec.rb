require 'spec_helper'

describe Reel do
  subject(:reel) { build :reel }

  it { should be_valid }

  describe 'associations' do
    it { should have_many :clips }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end
end
