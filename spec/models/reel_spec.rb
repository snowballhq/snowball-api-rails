require 'rails_helper'

describe Reel, type: :model do
  subject(:reel) { build :reel }

  it { is_expected.to be_valid }

  describe 'associations' do
    it { is_expected.to have_many :clips }
    it { is_expected.to have_many :participations }
    it { is_expected.to have_many(:participants).through(:participations).source(:user) }
  end

  describe '#recent_participants_names' do
    it 'returns a comma separated list of recent participants first names' do
      reel.name = nil
      clip = build :clip, reel: reel
      user = clip.user
      clip2 = build :clip, reel: reel
      user2 = clip2.user
      reel.participants << user
      reel.participants << user2
      user_first_name = user.name.split[0...-1].join ' '
      user2_first_name = user2.name.split[0...-1].join ' '
      expect(reel.recent_participants_names).to eq "#{user_first_name}, #{user2_first_name}"
    end
  end
end
