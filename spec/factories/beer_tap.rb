FactoryGirl.define do
  factory :beer_tap do
    sequence(:name) {|n| "Tap #{n}" }
  end
end
