require 'spec_helper'

describe Follow do
  subject(:follow) { build :follow }

  it { should be_valid }

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :followable }
  end

  describe 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :followable }
  end

  describe 'notifiable' do
    describe 'after_create' do
      describe '#create_notification' do
        it 'creates a new notification' do
          expect(follow.followable.notifications.count).to eq 0
          follow.save!
          expect(follow.followable.notifications.count).to eq 1
        end
      end
    end
    describe 'after_destroy' do
      describe '#destroy_notification' do
        it 'destroys the existing notification' do
          follow.save!
          expect(follow.followable.notifications.count).to eq 1
          follow.destroy!
          expect(follow.followable.notifications.count).to eq 0
        end
      end
    end
  end
end
