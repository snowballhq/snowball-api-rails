FactoryGirl.define do
  factory :user do
    username { FFaker::Internet.user_name }
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
    phone_number { FFaker::PhoneNumber.short_phone_number }
    avatar_file_name 'image.png'
    avatar_content_type 'image/png'
  end
end
