FactoryGirl.define do
  factory :user do
    username { Faker::Internet.user_name }
    password { Faker::Internet.password }
    phone_number { Faker::Base.numerify('1415#3##47#') }
  end
end
