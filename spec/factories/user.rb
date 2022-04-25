FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "John #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:rfid) { |n| "rfid-#{n}" }

    trait :guest do
      id { 0 }
      name { "Guest" }
    end
  end
end
