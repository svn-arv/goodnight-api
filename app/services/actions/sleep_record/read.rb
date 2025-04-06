module Actions
  module SleepRecord
    class Read < Actions::Base
      def call(filters:, pagination_params: nil)
        collection = SleepRecord.where(filters)
        return paginate(collection, page: pagination_params[:page], per_page: pagination_params[:per_page]) if pagination_params.present?

        collection.all
      end
    end
  end
end
