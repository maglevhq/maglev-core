# frozen_string_literal: true

module Maglev
  module API
    class SitesController < ::Maglev::APIController
      def show
        @site = current_site
        @home_page_id = model_scopes(:page).home.pick(:id)
        head :not_found if @site.nil?
      end
    end
  end
end
