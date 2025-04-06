require 'rails_helper'

RSpec.describe Actions::SleepRecord::ClockOut do
  let(:user) { create(:user, name: 'sleepy_user') }
  let(:sleep_record) { create(:sleep_record, user: user, start_at: Time.zone.now - 8.hours) }
  let(:time) { '2025-01-01 23:00:00' }

  describe '#call' do
    it 'updates a sleep record with the given end time' do
      expect(sleep_record.end_at).to be_nil

      described_class.call(sleep_record: sleep_record, time: time)
      sleep_record.reload

      expect(sleep_record.end_at.strftime('%Y-%m-%d %H:%M:%S')).to eq(time)
    end

    it 'updates a sleep record with the current time when no time is given' do
      freeze_time = Time.zone.now
      allow(Time.zone).to receive(:now).and_return(freeze_time)

      described_class.call(sleep_record: sleep_record)
      sleep_record.reload

      expect(sleep_record.end_at).to eq(freeze_time)
    end

    it 'does nothing when sleep_record is nil' do
      expect do
        described_class.call(sleep_record: nil)
      end.not_to(change { sleep_record.reload.end_at })
    end

    it 'handles invalid date format gracefully' do
      described_class.call(sleep_record: sleep_record, time: 'not-a-date')
      sleep_record.reload

      # Should use current time
      expect(sleep_record.end_at).to be_within(5.seconds).of(Time.zone.now)
    end

    it 'calculates the duration when end time is set' do
      start_time = sleep_record.start_at
      end_time = start_time + 8.hours
      expected_duration = (end_time - start_time).to_i

      described_class.call(sleep_record: sleep_record, time: end_time.to_s)
      sleep_record.reload

      expect(sleep_record.duration_in_seconds).to eq(expected_duration)
    end

    it 'uses advisory locks for safety' do
      expect_any_instance_of(described_class).to receive(:with_advisory_lock).and_call_original
      described_class.call(sleep_record: sleep_record)
    end

    it 'returns success when updating the record' do
      described_class.call(sleep_record: sleep_record)
      expect(described_class.success?).to be true
    end

    it 'tracks errors when update fails' do
      allow(sleep_record).to receive(:update).and_raise(StandardError.new('Update failed'))
      described_class.call(sleep_record: sleep_record)

      expect(described_class.success?).to be false
      expect(described_class.errors.full_messages).to include('Base Update failed')
    end
  end
end
