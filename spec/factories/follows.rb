# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :follow do
    follower { create(:user) }
    following { create(:user) }
  end
end
