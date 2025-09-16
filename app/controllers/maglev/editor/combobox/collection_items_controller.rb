# frozen_string_literal: true

module Maglev
  module Editor
    module Combobox
      class CollectionItemsController < Maglev::Editor::BaseController
        def index
          @items = services.fetch_collection_items.call(
            collection_id: params[:collection_id],
            keyword: params[:query]
          )
          response.set_header('X-Select-Options-Size', @items.size)
        end
      end
    end
  end
end
