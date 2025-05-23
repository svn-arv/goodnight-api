module Actions
  module Relationship
    class Unfollow < Actions::Base
      def call(user:, following:)
        with_advisory_lock(::Relationship) do
          ::Relationship.find_by(user_id: user.id, following_id: following.id)&.destroy
        end
      end
    end
  end
end
