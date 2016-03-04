# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device do
    user
    development false
    platform 0
    token Faker::Lorem.characters(10)
  end
end
