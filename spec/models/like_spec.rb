require 'spec_helper'

describe Like do
  subject(:like) { build :like }

  it { should be_valid }

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to(:likeable).counter_cache true }
  end

  describe 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :likeable }
  end

  describe 'notifiable' do
    describe 'after_create' do
      describe '#create_notification' do
        it 'creates a new notification' do
          expect(like.likeable.user.notifications.count).to eq 0
          like.save!
          expect(like.likeable.user.notifications.count).to eq 1
        end
      end
    end
    describe 'after_destroy' do
      describe '#destroy_notification' do
        it 'destroys the existing notification' do
          like.save!
          expect(like.likeable.user.notifications.count).to eq 1
          like.destroy!
          expect(like.likeable.user.notifications.count).to eq 0
        end
      end
    end
  end
end
