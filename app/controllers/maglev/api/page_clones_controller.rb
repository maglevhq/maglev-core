# frozen_string_literal: true

module Maglev
  module API
    class PageClonesController < ::Maglev::APIController
      def create
        page = clone_page(resources.find(params[:page_id]))
        head :created, location: api_page_path(page)
      end

      private

      def clone_page(page)
        services.clone_page.call(page: page)
      end

      def resources
        services.get_model_scopes.call[:page]
      end
    end
  end
end
