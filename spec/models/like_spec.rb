require 'rails_helper'

RSpec.describe Like, type: :model do
  subject(:like) { build(:like) }

  it { is_expected.to be_valid }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:clip) }
    it { is_expected.to validate_presence_of(:user) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:clip) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'after_create' do
    it 'sends a push notification' do
      # TODO: test this
    end
  end
end
