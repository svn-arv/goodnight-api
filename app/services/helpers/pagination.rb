module Helpers
  class Pagination
    MINIMUM_PAGE = 1
    DEFAULT_PAGE = 1
    DEFAULT_PER_PAGE = 10
    MAX_PER_PAGE = 100

    def initialize(page: nil, per_page: nil)
      @page = page || DEFAULT_PAGE
      @per_page = per_page || DEFAULT_PER_PAGE
    end

    def paginate(collection)
      page = [@page.to_i, MINIMUM_PAGE].max
      per_page = [@per_page.to_i, MAX_PER_PAGE].min

      # Apply pagination at the database level
      # This ensures we don't load the entire collection
      paginated_collection = collection.page(page).per(per_page)

      {
        items: paginated_collection,
        pagination: {
          current_page: page,
          total_pages: (paginated_collection.total_count.to_f / per_page).ceil,
          total_count: paginated_collection.total_count,
          per_page: per_page
        }
      }
    end
  end
end
