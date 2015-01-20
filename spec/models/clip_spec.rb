require 'rails_helper'

RSpec.describe Clip, type: :model do
  subject(:clip) { build(:clip) }

  it { is_expected.to be_valid }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_attachment_presence(:video) }
    it { is_expected.to validate_attachment_content_type(:video) }
    it { is_expected.to validate_attachment_presence(:thumbnail) }
    it { is_expected.to validate_attachment_content_type(:thumbnail) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:flags) }
  end
end
