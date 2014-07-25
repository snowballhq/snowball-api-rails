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

  describe '#message' do
    it 'returns the correct message by notification type' do
      expect(notification.notifiable).to receive :push_notification_message
      notification.message
    end
  end
end
