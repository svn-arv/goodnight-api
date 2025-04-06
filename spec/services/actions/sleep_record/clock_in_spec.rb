require 'rails_helper'

RSpec.describe Actions::SleepRecord::ClockIn do
  let(:user) { create(:user) }
  let(:read_service) { instance_double(Actions::SleepRecord::Read) }
  let(:read_result) { [build(:sleep_record)] }

  before do
    allow(Actions::SleepRecord::Read).to receive(:call).and_return(
      double(result: read_result, success?: true)
    )
  end

  describe '.call' do
    context 'when no time is provided' do
      it 'creates a sleep record with current time' do
        Timecop.freeze(Time.zone.now) do
          expect do
            result = described_class.call(user: user)
            expect(result.success?).to be true
          end.to change(SleepRecord, :count).by(1)

          record = SleepRecord.last
          expect(record.user_id).to eq(user.id)
          expect(record.start_at).to eq(Time.zone.now)
          expect(record.end_at).to be_nil
        end
      end
    end

    context 'when time is provided as string' do
      let(:time_string) { '2023-01-01T22:00:00Z' }
      let(:parsed_time) { DateTime.parse(time_string) }

      before do
        allow(Helpers::DateTime).to receive(:parseable?).with(time_string).and_return(true)
      end

      it 'creates a sleep record with the parsed time' do
        expect do
          result = described_class.call(user: user, time: time_string)
          expect(result.success?).to be true
        end.to change(SleepRecord, :count).by(1)

        record = SleepRecord.last
        expect(record.user_id).to eq(user.id)
        expect(record.start_at).to eq(parsed_time)
        expect(record.end_at).to be_nil
      end
    end

    context 'when time is not parseable' do
      let(:invalid_time) { 'not a time' }

      it 'uses current time instead' do
        Timecop.freeze(Time.zone.now) do
          expect do
            result = described_class.call(user: user, time: invalid_time)
            expect(result.success?).to be true
          end.to change(SleepRecord, :count).by(1)

          record = SleepRecord.last
          expect(record.start_at).to eq(Time.zone.now)
        end
      end
    end

    context 'when an error occurs' do
      before do
        allow_any_instance_of(described_class).to receive(:call).and_raise(StandardError.new('Test error'))
      end

      it 'handles the error and returns failure' do
        result = described_class.call(user: user)
        expect(result.success?).to be false
        expect(result.error_message).to eq('Test error')
      end
    end
  end
end
