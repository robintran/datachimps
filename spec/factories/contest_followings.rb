# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contest_following do
    contest
    user
  end
end
