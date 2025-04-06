module Actions
  module Relationship
    class Follow < Actions::Base
      def call(user:, following:)
        with_advisory_lock(::Relationship) do
          ::Relationship.create!(user_id: user.id, following_id: following.id) unless ::Relationship.exists?(user_id: user.id, following_id: following.id)
        end
      end
    end
  end
end
