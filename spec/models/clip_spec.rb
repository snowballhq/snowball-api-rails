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

  describe '#encode_video' do
    # TODO: write spec
  end
end
