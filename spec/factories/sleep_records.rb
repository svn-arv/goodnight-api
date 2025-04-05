FactoryBot.define do
  factory :sleep_record do
    sleep_start_at { "2025-04-05 15:28:39" }
    sleep_end_at { "2025-04-05 15:28:39" }
    sleep_duration_in_seconds { 1 }
    awake_start_at { "2025-04-05 15:28:39" }
    awake_end_at { "2025-04-05 15:28:39" }
    awake_duration_in_seconds { 1 }
  end
end
