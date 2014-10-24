require 'rails_helper'

RSpec.describe Reel, type: :model do
  subject(:reel) { build(:reel) }

  it { is_expected.to be_valid }

  describe 'associations' do
    it { is_expected.to have_many(:clips) }
    it { is_expected.to have_many(:participations) }
    it { is_expected.to have_many(:users).through(:participations) }
  end

  describe '#users_title' do
    it 'returns the first names of the last five users' do
      reel.save!
      create_list(:participation, 6, reel: reel)
      users_title = reel.reload.users.last(5).map(&:name).map do |n|
        [n.split.first].join(' ') unless n.nil?
      end.join(', ')
      expect(reel.users_title).to eq(users_title)
    end
  end

  describe '#next_clip(user)' do
    context 'when clips exist in the reel' do
      context 'when the user has previously watched a clip in this reel' do
        it 'returns the next clip' do
          reel.save!
          clips = create_list(:clip, 2, reel: reel)
          participation = create(:participation, reel: reel, last_watched_clip: clips.first)
          expect(reel.next_clip(participation.user)).to eq(clips.last)
        end
      end
      context 'when the user has never watched a clip in this reel' do
        it 'returns the 10th most recent clip' do
          reel.save!
          clips = create_list(:clip, 11, reel: reel)
          participation = create(:participation, reel: reel, last_watched_clip: nil)
          expect(reel.next_clip(participation.user)).to eq(clips.second)
        end
      end
    end
    context 'when no clips exist in the reel' do
      it 'returns nil' do
        reel.save!
        participation = create(:participation, reel: reel, last_watched_clip: nil)
        expect(reel.next_clip(participation.user)).to be_nil
      end
    end
  end
end
