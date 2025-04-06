require 'rails_helper'

RSpec.describe SleepRecord do
  let(:user) { create(:user) }

  it 'calculates duration automatically' do
    start_time = Time.zone.now - 8.hours
    end_time = Time.zone.now
    expected_duration = (end_time - start_time).to_i

    sleep_record = described_class.new(
      user: user,
      start_at: start_time,
      end_at: end_time
    )

    expect(sleep_record.duration_in_seconds).to eq(expected_duration)
  end
end
