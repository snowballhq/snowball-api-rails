# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :like do
    association :likeable, factory: :clip
    user
  end
end
