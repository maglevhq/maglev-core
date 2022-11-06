# frozen_string_literal: true

module Maglev
  module Api
    class SitesController < ::Maglev::ApiController
      def show
        if (@site = maglev_site).present?
          @home_page_id = maglev_page_collection.home.pick(:id)
        else
          head :not_found
        end
      end

      private

      def maglev_page_collection
        ::Maglev::Page
      end
    end
  end
end
