# frozen_string_literal: true

module Maglev
  module Editor
    class SectionsStoresController < Maglev::Editor::BaseController
      def index
        @sections_stores = current_maglev_page_content.stores
      end
    end
  end
end
