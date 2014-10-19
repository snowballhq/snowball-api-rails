# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reel do
    title { Faker::Team.name }
  end
end
