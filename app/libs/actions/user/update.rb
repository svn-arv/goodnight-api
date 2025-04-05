module Actions
  module User
    class Destroy < Actions::Base
      def call(user:, attributes:)
        user.update(attributes)
      end
    end
  end
end
