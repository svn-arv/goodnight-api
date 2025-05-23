# == Schema Information
#
# Table name: sleep_records
#
#  id                  :integer          not null, primary key
#  duration_in_seconds :integer
#  end_at              :datetime
#  start_at            :datetime         not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :integer          not null
#
# Indexes
#
#  index_sleep_records_on_user_id               (user_id)
#  index_sleep_records_on_user_id_and_start_at  (user_id,start_at) UNIQUE
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class SleepRecord < ApplicationRecord
  belongs_to :user
  after_initialize :calculate_duration

  scope :on_or_before, ->(filter, date) { where("#{filter} <= ?", date) }
  scope :on_or_after, ->(filter, date) { where("#{filter} >= ?", date) }

  private

  def calculate_duration
    self.duration_in_seconds = (end_at.to_i - start_at.to_i) if end_at && start_at
  end
end
