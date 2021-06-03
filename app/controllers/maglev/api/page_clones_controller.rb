# frozen_string_literal: true

module Maglev
  module API
    class PageClonesController < ::Maglev::APIController
      def create
        original_page = model_scopes(:page).find(params[:page_id])
        page = services.clone_page.call(page: original_page)
        head :created, location: api_page_path(page)
      end
    end
  end
end
