require 'rails_helper'

describe Participation, type: :model do
  subject(:participation) { build :participation }

  it { is_expected.to be_valid }

  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :reel }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :reel }
  end
end
