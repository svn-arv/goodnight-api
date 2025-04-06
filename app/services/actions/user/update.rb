module Actions
  module User
    class Update < Actions::Base
      def call(user:, attributes:)
        with_advisory_lock(User) do
          user.update(attributes)
        end
      end
    end
  end
end
