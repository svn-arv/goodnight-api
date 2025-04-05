# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

# User Seeds
if User.last.blank?
  100.times do
    User.create!(name: Faker::Name.name)
  end
end

# Sleep Record Seeds
if SleepRecord.last.blank? && User.last.present?
  users = User.all
  100.times do |i|
    SleepRecord.create!(user_id: users.sample.id, start_at: Time.zone.now - i.days, end_at: Time.zone.now - i.days + rand(10).hours)
  end
end

if Relationship.last.blank? && User.last.present?
  users = User.all
  100.times do
    user = users.sample
    following = (users - [user]).sample

    Relationship.create!(user_id: user.id, following_id: following.id) unless Relationship.exists?(user_id: user.id, following_id: following.id)
  end
end
