require 'rails_helper'

describe Clip, type: :model do
  subject(:clip) { build :clip }

  it { is_expected.to be_valid }

  describe 'associations' do
    it { is_expected.to belong_to(:reel).touch true }
    it { is_expected.to belong_to :user }
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for :reel }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :reel }
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to have_attached_file :video }
    it { is_expected.to validate_attachment_presence :video }
  end

  describe '#push_notification_message' do
    it 'returns a push notification message' do
      "#{clip.user.username} added a clip to \"#{clip.reel.friendly_name}\""
    end
  end

  describe '#video_url' do
    it 'provides the correct video url' do
      ENV['S3_BUCKET_NAME'] = 'snowball-development'
      expect(clip.video_url).to eq("https://snowball-development.s3.amazonaws.com/clips/videos/#{clip.id}/original/video.mp4")
    end
  end

  describe 'notifiable' do
    before :each do
      clip.reel.participants = create_list(:user, 3)
    end
    describe '#create_notification' do
      it 'creates a new notification for every user in the reel' do
        expect do
          clip.save!
        end.to change(Notification, :count).by 3
      end
    end
    describe 'after_destroy' do
      describe '#destroy_notification' do
        it 'deletes the notifications for every user in the reel' do
          clip.save!
          expect do
            clip.destroy!
          end.to change(Notification, :count).by(-3)
        end
      end
    end
  end
end
