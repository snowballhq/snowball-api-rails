# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reel do
    name { Faker::Internet.domain_word }
  end
end
