# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entry do
    association(:contest, factory: :contest)
    association(:user, factory: :user)
    description "MyText"
    data_set_url "MyString"
  end
end
