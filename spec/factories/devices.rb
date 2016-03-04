# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device do
    user
    arn Faker::Lorem.characters(10)
  end
end
