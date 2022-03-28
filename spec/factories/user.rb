FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "John #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:rfid) { |n| "rfid-#{n}" }
  end
end
