# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :clip do
    reel
    video Rack::Test::UploadedFile.new(Rails.root + 'spec/support/video.mp4', 'video/mp4')
  end
end
