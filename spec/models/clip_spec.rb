require 'spec_helper'

describe Clip do
  it { should have_attached_file :video }
end
