# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :clip do
    reel
    user
    video_file_name { 'video.mp4' }
    video_content_type { 'video/mp4' }
  end
end
