module Actions
  module SleepRecord
    class ClockIn
      def self.call(user:, time: nil)
        return unless user

        time = DateTime.parse(time) if time.present? && Helpers::DateTime.parseable?(time)

        ::SleepRecord.create!(user_id: user.id, start_at: time || Time.zone.now)
      end
    end
  end
end
