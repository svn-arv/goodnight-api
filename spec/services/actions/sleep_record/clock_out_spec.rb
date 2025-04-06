require 'rails_helper'

RSpec.describe Actions::SleepRecord::ClockOut do
  let(:user) { create(:user) }
  let(:sleep_record) { create(:sleep_record, user: user, start_at: 1.hour.ago, end_at: nil) }

  describe '.call' do
    context 'when no time is provided' do
      it 'updates the sleep record with current time' do
        Timecop.freeze(Time.zone.now) do
          expect do
            result = described_class.call(sleep_record: sleep_record)
            expect(result.success?).to be true
          end.to change { sleep_record.reload.end_at }.from(nil).to(Time.zone.now)
        end
      end
    end

    context 'when time is provided as string' do
      let(:time_string) { (Time.zone.now + 3.hours).to_s }
      let(:parsed_time) { DateTime.parse(time_string) }

      before do
        allow(Helpers::DateTime).to receive(:parseable?).with(time_string).and_return(true)
      end

      it 'updates the sleep record with the parsed time' do
        expect do
          result = described_class.call(sleep_record: sleep_record, time: time_string)
          expect(result.success?).to be true
        end.to change { sleep_record.reload.end_at }.from(nil).to(parsed_time)
      end

      it 'calculates the duration after updating' do
        described_class.call(sleep_record: sleep_record, time: time_string)
        expect(sleep_record.reload.duration_in_seconds).to be_present

        expected_duration = parsed_time.to_i - sleep_record.start_at.to_i
        expect(sleep_record.duration_in_seconds).to eq(expected_duration)
      end
    end

    context 'when time is not parseable' do
      let(:invalid_time) { 'not a time' }

      before do
        allow(Helpers::DateTime).to receive(:parseable?).with(invalid_time).and_return(false)
      end

      it 'uses current time instead' do
        Timecop.freeze(Time.zone.now) do
          expect do
            result = described_class.call(sleep_record: sleep_record, time: invalid_time)
            expect(result.success?).to be true
          end.to change { sleep_record.reload.end_at }.from(nil).to(Time.zone.now)
        end
      end
    end

    context 'when an error occurs' do
      before do
        allow_any_instance_of(described_class).to receive(:call).and_raise(StandardError.new('Test error'))
      end

      it 'handles the error and returns failure' do
        result = described_class.call(sleep_record: sleep_record)
        expect(result.success?).to be false
        expect(result.error_message).to eq('Test error')
      end
    end
  end
end
