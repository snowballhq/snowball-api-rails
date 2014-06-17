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
      it 'returns a comma separated list of recent participants' do
        reel.name = nil
        clip = build :clip, reel: reel
        user = clip.user
        reel.participants << user
        expect(reel.friendly_name).to eq [user.name]
      end
    end
  end
end
