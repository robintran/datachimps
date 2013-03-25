# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feedback do
    association(:entry, factory: :entry)
    association(:user, factory: :user)
    content "MyText"
  end
end
