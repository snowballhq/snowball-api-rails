require 'spec_helper'

describe Reel do
  subject(:reel) { build :reel }

  it { should be_valid }

  describe 'associations' do
    it { should have_many :clips }
    it { should have_many :participations }
    it { should have_many(:participants).through(:participations).source(:user) }
  end

  describe '#recent_participants' do
    it 'returns the 5 most recent participants' do
      6.times do
        u = build :user
        reel.participants << u
      end
      reel.save
      expect(reel.recent_participants.count).to eq 5
    end
  end

  describe '#friendly_name' do
    context 'when the reel name exists' do
      it 'returns the name if a name exists' do
        expect(reel.friendly_name).to eq reel.name
      end
    end
    context 'when the reel name does not exist' do
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
        expect(reel.friendly_name).to eq "#{user_first_name}, #{user2_first_name}"
      end
    end
  end
end
