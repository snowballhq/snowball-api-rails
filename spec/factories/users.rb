FactoryGirl.define do
  factory :user do
    username { Faker::Lorem.characters(10) }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    phone_number { Faker::Base.numerify('1415#3##47#') }
    avatar_file_name 'image.png'
    avatar_content_type 'image/png'
  end
end
