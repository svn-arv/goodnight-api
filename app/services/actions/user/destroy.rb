module Actions
  module User
    class Destroy < Actions::Base
      def call(user:)
        with_advisory_lock(::User) do
          user.destroy!
        end
      end
    end
  end
end
