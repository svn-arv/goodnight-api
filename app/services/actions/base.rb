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
