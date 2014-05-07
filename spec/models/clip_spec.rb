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
    it do
      should validate_attachment_content_type(:video)
      .allowing('video/mp4').rejecting 'image/png'
    end
  end
end
