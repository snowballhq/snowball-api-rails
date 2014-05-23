require 'spec_helper'

describe Clip do
  subject(:clip) { build :clip }

  it { should be_valid }

  describe 'associations' do
    it { should belong_to :reel }
    it { should belong_to :user }
    it { should have_many :likes }
  end

  describe 'validations' do
    it { should validate_presence_of :reel }
    it { should validate_presence_of :user }
    it { should have_attached_file :video }
    it { should validate_attachment_presence :video }
    # no shoulda matcher for validates_attachment_file_name, so no spec written
  end

  describe 'after_create' do
    it 'calls #encode_video' do
      # no testing since this is hitting a remote service
      expect(clip).to receive :encode_video
      clip.save!
    end
  end

  describe 'VideoEncoder' do
    describe '#thumbnail_filename' do
      it 'provides the correct thumbnail_filename' do
        expect(clip.thumbnail_filename).to eq '640x360'
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
        expect(clip.thumbnail_url).to eq("https://snowball-development.s3.amazonaws.com/clips/videos/#{clip.id}/thumbnails/640x360.png")
      end
    end

    describe '#encoded_video_path' do
      it 'provides the correct encoded_video_path' do
        expect(clip.encoded_video_path).to eq "clips/videos/#{clip.id}/540p/video.mp4"
      end
    end

    describe '#encoded_video_url' do
      it 'provides the correct encoded_video_url' do
        expect(clip.encoded_video_url).to eq("https://snowball-development.s3.amazonaws.com/clips/videos/#{clip.id}/540p/video.mp4")
      end
    end
  end

  describe '#user_has_liked?' do
    before :each do
      clip.save!
    end
    it 'returns true if the user has liked the clip' do
      clip.likes.create!(user: clip.user)
      expect(clip.user_has_liked?(clip.user)).to be_true
    end
    it 'returns false if the user has not liked the clip' do
      expect(clip.user_has_liked?(clip.user)).to be_false
    end
  end
end
