# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contest do
    association(:user, factory: :user)
    name "MyString"
    description "MyText"
    deadline "2013-03-07 00:56:56"
    bounty 1
  end
end
