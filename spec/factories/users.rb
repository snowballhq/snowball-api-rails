FactoryGirl.define do
  factory :user do
    username { Faker::Internet.user_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    phone_number { Faker::Base.numerify('1415#3##47#') }
  end
end
