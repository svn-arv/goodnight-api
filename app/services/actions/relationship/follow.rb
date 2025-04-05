module Actions
  module Relationship
    class Follow
      def self.call(user:, following:)
        return unless user && following && user != following

        Relationship.create!(user_id: user.id, following_id: following.id) unless Relationship.exists?(user_id: user.id, following_id: following.id)
      end
    end
  end
end
