require 'spec_helper'

describe Participation do
  subject(:participation) { build :participation }

  it { should be_valid }

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :reel }
  end

  describe 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :reel }
  end
end
