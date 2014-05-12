require 'spec_helper'

describe Clip do
  subject(:clip) { build :clip }

  it { should be_valid }

  describe 'associations' do
    it { should belong_to :reel }
  end

  describe 'validations' do
    it { should have_attached_file :video }
    it { should validate_attachment_presence :video }
    # no shoulda matcher for validates_attachment_file_name, so no spec written
  end

  describe 'after_create' do
    it 'calls #encode_video' do
      expect(clip).to receive :encode_video
      clip.save!
    end
  end

  describe '#encoded_video_path' do
    it 'provides the correct encoded_video_path' do
      clip.save!
      expect(clip.encoded_video_path).to eq "clips/videos/#{clip.id}/540p/video.mp4"
    end
  end

  describe '#encoded_video_url' do
    it 'provides the correct encoded_video_url' do
      clip.save!
      expect(clip.encoded_video_url).to eq("https://snowball-development-clips.s3.amazonaws.com/clips/videos/#{clip.id}/540p/video.mp4")
    end
  end

  describe 'VideoEncoder' do
    # TODO: write VideoEncoder concern specs
  end
end
