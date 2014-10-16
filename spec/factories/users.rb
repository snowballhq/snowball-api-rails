FactoryGirl.define do
  factory :user do
    phone_number { Faker::Number.number(10) }
  end
end
