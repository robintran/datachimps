FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "12345678" }
    password_confirmation { "12345678" }
    name { "John Doe" }
    balanced_account_uri { "test_uri" }

    factory :user_with_oauth do
      provider { "facebook" }
      uid { "123456" }
    end
  end
end