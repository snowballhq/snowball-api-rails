require 'rails_helper'

describe Notification, type: :model do
  subject(:notification) { build :notification }

  it { is_expected.to be_valid }

  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :notifiable }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :notifiable }
  end

  describe 'after_create' do
    it 'calls #send_push_notification' do
      # no testing since this is hitting a remote service
      expect(notification).to receive :send_push_notification
      notification.save!
    end
  end

  describe '#action' do
    it 'returns the lowercase notifiable_type' do
      expect(notification.action).to eq 'follow'
    end
  end

  describe '#new_follower' do
    it 'returns the notification\'s user\'s new follower' do
      expect(notification.new_follower).to eq notification.notifiable.user
    end
  end

  describe '#message' do
    it 'returns the correct message by notification type' do
      expect(notification.message).to eq "#{notification.notifiable.user.username} has followed you."
    end
  end
end
