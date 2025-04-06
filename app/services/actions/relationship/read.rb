module Actions
  module Relationship
    class Read < Actions::Base
      def call(filters:, scopes: [], order: { created_at: :desc }, pagination_params: nil)
        collection = ::Relationship.where(filters)
        return paginate(collection, page: pagination_params[:page], per_page: pagination_params[:per_page]) if pagination_params.present?

        collection.order(order).all
      end
    end
  end
end
