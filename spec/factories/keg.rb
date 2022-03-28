FactoryBot.define do
  factory :keg do
    sequence(:name) { |n| "Beer #{n}" }
    capacity { "636" }
    beer_tap
  end
end
