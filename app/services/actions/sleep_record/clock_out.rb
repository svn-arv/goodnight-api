module Actions
  module SleepRecord
    class ClockOut < Actions::Base
      def call(sleep_record:, time: nil)
        with_advisory_lock(::SleepRecord) do
          return unless sleep_record

          time = DateTime.parse(time) if time.present? && Helpers::DateTime.parseable?(time)

          sleep_record.update(end_at: time || Time.zone.now)
        end
      end
    end
  end
end
