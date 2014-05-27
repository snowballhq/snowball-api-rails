# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :identity do
    uid SecureRandom.hex
    provider 'facebook'
    user
  end
end
