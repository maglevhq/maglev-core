# frozen_string_literal: true

module Maglev
  module API
    class SitesController < ::Maglev::APIController
      def show
        @site = maglev_site
        @home_page_id = ::Maglev::Page.home.pick(:id)
        head :not_found if @site.nil?
      end
    end
  end
end
