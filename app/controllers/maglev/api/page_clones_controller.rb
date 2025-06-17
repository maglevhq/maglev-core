# frozen_string_literal: true

module Maglev
  module Api
    class PageClonesController < ::Maglev::ApiController
      def create
        @page = clone_page(resources.find(params[:page_id]))
      end

      private

      def clone_page(page)
        services.clone_page.call(page: page)
      end

      def resources
        ::Maglev::Page
      end
    end
  end
end
