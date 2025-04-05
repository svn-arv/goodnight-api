module Actions
  class Base
    def self.call(*, **)
      new.call(*, **)
    end

    def call(*, **)
      ActiveRecord::Base.transaction do
        super
      end
    end
  end
end
