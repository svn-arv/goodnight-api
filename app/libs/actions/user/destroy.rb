module Actions
  module User
    class Destroy < Actions::Base
      def call(user:)
        user.destroy!
      end
    end
  end
end
