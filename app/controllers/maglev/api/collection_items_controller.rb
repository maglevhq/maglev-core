# frozen_string_literal: true

module Maglev
  module Api
    class CollectionItemsController < ::Maglev::ApiController
      def index
        @items = services.fetch_collection_items.call(
          collection_id: params[:collection_id],
          keyword: params[:q]
        )
      end
    end
  end
end
