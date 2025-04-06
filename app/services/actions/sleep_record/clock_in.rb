module Actions
  module SleepRecord
    class ClockIn < Actions::Base
      def call(user:, time: nil)
        with_advisory_lock(SleepRecord) do
          return unless user

          time = DateTime.parse(time) if time.present? && Helpers::DateTime.parseable?(time)

          ::SleepRecord.create!(user_id: user.id, start_at: time || Time.zone.now)
        end
      end
    end
  end
end
