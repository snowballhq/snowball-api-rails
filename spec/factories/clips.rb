# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :clip do
    user
    video_file_name 'video.mp4'
    video_content_type 'video/mp4'
    thumbnail_file_name 'image.png'
    thumbnail_content_type 'image/png'
  end
end
