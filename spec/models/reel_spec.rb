require 'rails_helper'

RSpec.describe Reel, type: :model do
  subject(:reel) { build(:reel) }

  it { is_expected.to be_valid }

  describe 'associations' do
    it { is_expected.to have_many(:clips) }
    it { is_expected.to have_many(:participations) }
    it { is_expected.to have_many(:users).through(:participations) }
  end

  describe '#subtitle' do
    it 'returns the first names of the last five users' do
      reel = create(:reel)
      create_list(:participation, 6, reel: reel)
      subtitle = reel.reload.users.last(5).map(&:name).map do |n|
        [n.split.first].join ' '
      end.join(', ')
      expect(reel.subtitle).to eq(subtitle)
    end
  end
end
