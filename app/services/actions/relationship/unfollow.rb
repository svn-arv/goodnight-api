module Actions
  module Relationship
    class Unfollow < Actions::Base
      def call(user:, following:)
        return unless user && following && user != following

        ::Relationship.find_by(user_id: user.id, following_id: following.id)&.destroy
      end
    end
  end
end
