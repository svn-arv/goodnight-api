# == Schema Information
#
# Table name: relationships
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  following_id :integer          not null
#  user_id      :integer          not null
#
# Indexes
#
#  index_relationships_on_following_id              (following_id)
#  index_relationships_on_user_id                   (user_id)
#  index_relationships_on_user_id_and_following_id  (user_id,following_id) UNIQUE
#
# Foreign Keys
#
#  following_id  (following_id => users.id)
#  user_id       (user_id => users.id)
#
class Relationship < ApplicationRecord
  belongs_to :user
  belongs_to :following, class_name: 'User'

  scope :followers, ->(user) { where(following: user) }
  scope :followings, ->(user) { where(user: user) }
end
