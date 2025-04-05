# == Schema Information
#
# Table name: relationships
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  following_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :relationship do
    user { nil }
    followers { nil }
    followings { nil }
  end
end
