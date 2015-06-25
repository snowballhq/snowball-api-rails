require 'rails_helper'

RSpec.describe Clip, type: :model do
  subject(:clip) { build(:clip) }

  it { is_expected.to be_valid }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_attachment_content_type(:video) }
    it { is_expected.to validate_attachment_content_type(:thumbnail) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:flags).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
  end

  describe '#video_upload_url' do
    it 'generates a new file upload url' do
      clip.video = nil
      clip.save!
      url = clip.video_upload_url
      expect(URI.parse(url)).to be_a_kind_of(URI::HTTPS)
      expected_url = "https://#{ENV['S3_BUCKET_NAME']}.s3.amazonaws.com/clips/#{clip.id}/video.mp4"
      expect(url.include?(expected_url)).to be_truthy
    end
  end

  describe '#thumbnail_upload_url' do
    it 'generates a new file upload url' do
      clip.thumbnail = nil
      clip.save!
      url = clip.thumbnail_upload_url
      expect(URI.parse(url)).to be_a_kind_of(URI::HTTPS)
      expected_url = "https://#{ENV['S3_BUCKET_NAME']}.s3.amazonaws.com/clips/#{clip.id}/thumbnail.png"
      expect(url.include?(expected_url)).to be_truthy
    end
  end
end
