require 'rails_helper'

RSpec.describe Reel, type: :model do
  subject(:reel) { build(:reel) }

  it { is_expected.to be_valid }
end
