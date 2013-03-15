FactoryGirl.define do
  factory :keg do
    sequence(:name) {|n| "Beer #{n}" }
    capacity "636"
  end
end
