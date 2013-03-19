# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit_card do
    user
    security_code { rand(999) }
    card_number { rand(100000) }
    name { Faker::Lorem.word }
    expiration_month { 1.month.from_now.month }
    expiration_year { 1.year.from_now.year }
  end
end
