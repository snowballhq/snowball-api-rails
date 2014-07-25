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
      user_first_name = [user.name.split.first].join ' '
      user2_first_name = [user2.name.split.first].join ' '
      expect(reel.recent_participants_names).to eq "#{user_first_name}, #{user2_first_name}"
    end
  end

  describe '#friendly_name' do
    context 'when the reel name exists' do
      it 'returns the name if a name exists' do
        expect(reel.friendly_name).to eq reel.name
      end
    end
    context 'when the reel name does not exist' do
      it 'returns #recent_participants_names' do
        reel.name = nil
        clip = build :clip, reel: reel
        user = clip.user
        clip2 = build :clip, reel: reel
        user2 = clip2.user
        reel.participants << user
        reel.participants << user2
        expect(reel.friendly_name).to eq reel.recent_participants_names
      end
    end
  end
end
