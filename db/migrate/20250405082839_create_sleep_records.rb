class CreateSleepRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :sleep_records do |t|
      t.references :user, null: false, foreign_key: true
      t.timestamp :start_at
      t.timestamp :end_at
      t.integer :duration_in_seconds

      t.timestamps
    end

    add_index :sleep_records, %i[user_id start_at], unique: true
  end
end
