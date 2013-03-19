FactoryGirl.define do
  factory :bank_account do
    user
    type { ['checking', 'savings'][rand(1)] }
    name { Faker::Lorem.word }
    account_number { rand(1000000) }
    routing_number { rand(1000000) }
  end
end
