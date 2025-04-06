module Actions
  module SleepRecord
    class ClockIn < Actions::Base
      def call(user:, time: nil)
        with_advisory_lock(::SleepRecord) do
          start_at = DateTime.parse(time) if time.present? && Helpers::DateTime.parseable?(time)

          ::SleepRecord.create!(user_id: user.id, start_at: start_at || Time.zone.now)

          Read.call(filters: { user: user }).result
        end
      end
    end
  end
end
