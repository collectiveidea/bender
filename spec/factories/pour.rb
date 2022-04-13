FactoryBot.define do
  factory :pour do
    volume { rand * 16 }
    started_at { 5.seconds.ago }
    finished_at { Time.now }
    duration { rand * 30 }
    keg
    user
  end
end
