module Actions
  class Base
    class << self
      attr_reader :errors, :result

      def success?
        @success
      end

      def error_message
        @errors.options[:message]
      end
    end

    def self.call(*, **)
      @result = new.call(*, **)
      self
    rescue StandardError => e
      @errors = ActiveModel::Errors.new(self).add(:base, message: e.message)
      self
    ensure
      @success = @errors.blank?
    end

    def call(*, **)
      ActiveRecord::Base.transaction do
        super
      end
    end

    def paginate(collection, page:, per_page:)
      pagination = Helpers::Pagination.new(page: page, per_page: per_page)
      pagination.paginate(collection)
    end

    def with_advisory_lock(model, &)
      lock_name = model.table_name
      model.with_advisory_lock(lock_name, &)
    end
  end
end
