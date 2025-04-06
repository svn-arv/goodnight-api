FactoryBot.define do
  factory :sleep_record do
    user { association(:user) }
    start_at { '2025-04-05 15:28:39' }
    end_at { '2025-04-05 15:28:39' }
    duration_in_seconds { 1 }
  end
end
