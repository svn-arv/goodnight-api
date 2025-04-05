module Actions
  module User
    class Update < Actions::Base
      def call(user:, attributes:)
        user.update(attributes)
      end
    end
  end
end
