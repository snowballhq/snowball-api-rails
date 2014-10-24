require 'rails_helper'

RSpec.describe Participation, type: :model do
  subject(:participation) { build(:participation) }

  it { is_expected.to be_valid }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:reel) }
    it { is_expected.to validate_presence_of(:user) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:reel) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:last_watched_clip).class_name('Clip') }
  end
end
