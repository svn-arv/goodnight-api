require 'rails_helper'

RSpec.describe Actions::SleepRecord::ClockIn do
  let(:user) { create(:user, name: 'sleepy_user') }
  let(:time) { '2025-01-01 23:00:00' }

  describe '#call' do
    it 'creates a sleep record with the given time' do
      expect do
        described_class.call(user: user, time: time)
      end.to change(SleepRecord, :count).by(1)

      sleep_record = SleepRecord.last
      expect(sleep_record.start_at.strftime('%Y-%m-%d %H:%M:%S')).to eq(time)
    end

    it 'creates a sleep record with the current time when no time is given' do
      freeze_time = Time.zone.now
      allow(Time.zone).to receive(:now).and_return(freeze_time)

      expect do
        described_class.call(user: user)
      end.to change(SleepRecord, :count).by(1)

      sleep_record = SleepRecord.last
      expect(sleep_record.start_at).to eq(freeze_time)
    end

    it 'does nothing when user is nil' do
      expect do
        described_class.call(user: nil)
      end.not_to change(SleepRecord, :count)
    end

    it 'handles invalid date format gracefully' do
      expect do
        described_class.call(user: user, time: 'not-a-date')
      end.to change(SleepRecord, :count).by(1)

      # Should use current time
      expect(SleepRecord.last.start_at).to be_within(5.seconds).of(Time.zone.now)
    end

    it 'uses advisory locks for safety' do
      expect_any_instance_of(described_class).to receive(:with_advisory_lock).and_call_original
      described_class.call(user: user)
    end

    it 'calls Read action after creating the record' do
      expect(Actions::SleepRecord::Read).to receive(:call).with(filter: { user: user })
      described_class.call(user: user)
    end

    it 'returns success when creating the record' do
      described_class.call(user: user)
      expect(described_class.success?).to be true
    end

    it 'tracks errors when creation fails' do
      allow(SleepRecord).to receive(:create!).and_raise(StandardError.new('Creation failed'))
      described_class.call(user: user)

      expect(described_class.success?).to be false
      expect(described_class.errors.full_messages).to include('Base Creation failed')
    end
  end
end
