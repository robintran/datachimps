# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contest do
    user
    name Faker::Lorem.word
    description Faker::Lorem.sentence
    deadline 1.month.from_now
    bounty { rand(100) }
  end
end
