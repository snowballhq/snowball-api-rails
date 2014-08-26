require 'rails_helper'

describe Clip, type: :model do
  subject(:clip) { build :clip }

  it { is_expected.to be_valid }

  describe 'associations' do
    it { is_expected.to belong_to(:reel).touch true }
    it { is_expected.to belong_to :user }
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for :reel }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :reel }
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to have_attached_file :video }
    it { is_expected.to validate_attachment_presence :video }
  end

  describe 'after_create' do
    it 'calls #encode_video' do
      # no testing since this is hitting a remote service
      expect(clip).to receive :encode_video
      clip.save!
    end
  end

  describe '#zencoder_job_id=(value)' do
    before :each do
      clip.reel.participants = create_list(:user, 3)
    end
    it 'creates a new notification for every user in the reel' do
      expect do
        clip.zencoder_job_id = 12345
      end.to change(Notification, :count).by 0
      expect do
        clip.zencoder_job_id = nil
      end.to change(Notification, :count).by 3
    end
  end

  describe '#push_notification_message' do
    it 'returns a push notification message' do
      "#{clip.user.username} added a clip to \"#{clip.reel.friendly_name}\""
    end
  end

  describe 'VideoEncoder' do
    describe '#thumbnail_filename' do
      it 'provides the correct thumbnail_filename' do
        expect(clip.thumbnail_filename).to eq 'thumbnail'
      end
    end

    describe '#thumbnail_path' do
      it 'provides the correct thumbnail_path_without_filename' do
        expect(clip.thumbnail_path_without_filename).to eq "clips/videos/#{clip.id}/thumbnails/"
      end
    end

    describe '#thumbnail_extension' do
      it 'provides the correct thumbnail_extension' do
        expect(clip.thumbnail_extension).to eq '.png'
      end
    end

    describe '#thumbnail_base_url' do
      it 'provides the correct thumbnail_base_url' do
        expect(clip.thumbnail_base_url).to eq("https://snowball-development.s3.amazonaws.com/clips/videos/#{clip.id}/thumbnails/")
      end
    end

    describe '#thumbnail_url' do
      it 'provides the correct thumbnail_url' do
        expect(clip.thumbnail_url).to eq("https://snowball-development.s3.amazonaws.com/clips/videos/#{clip.id}/thumbnails/thumbnail.png")
      end
      it 'returns nil if zencoder_job_id exists' do
        clip.zencoder_job_id = '123'
        expect(clip.thumbnail_url).to be_nil
      end
    end

    describe '#encoded_video_path' do
      it 'provides the correct encoded_video_path' do
        expect(clip.encoded_video_path).to eq "clips/videos/#{clip.id}/encoded/video.mp4"
      end
    end

    describe '#encoded_video_url' do
      it 'provides the correct encoded_video_url' do
        expect(clip.encoded_video_url).to eq("https://snowball-development.s3.amazonaws.com/clips/videos/#{clip.id}/encoded/video.mp4")
      end
      it 'returns nil if zencoder_job_id exists' do
        clip.zencoder_job_id = '123'
        expect(clip.encoded_video_url).to be_nil
      end
    end
  end

  describe 'notifiable' do
    before :each do
      clip.reel.participants = create_list(:user, 3)
    end
    describe 'after_destroy' do
      describe '#destroy_notification' do
        it 'deletes the notifications for every user in the reel' do
          clip.zencoder_job_id = nil
          clip.save!
          expect do
            clip.destroy!
          end.to change(Notification, :count).by(-3)
        end
      end
    end
  end
end
