# frozen_string_literal: true

module Maglev
  module API
    class PagesController < ::Maglev::APIController
      def index
        @pages = if params[:q]
                   resources.search(params[:q])
                 else
                   resources.all
                 end
      end

      def show
        @page = resources.by_id_or_path(params[:id]).first
        head :not_found if @page.nil?
      end

      def create
        page = persist!(resources.new)
        head :created, location: api_page_path(page)
      end

      def destroy
        resources.destroy(params[:id])
        head :no_content
      end

      def update
        @page = resources.find(params[:id])
        persist!(@page)
        head :ok
      end

      private

      def page_params
        params.require(:page).permit(:title, :path, :seo_title, :meta_description, :visible).tap do |whitelisted|
          whitelisted[:sections] = params[:page].to_unsafe_hash[:sections] unless params.dig(:page, :sections).nil?
        end
      end

      def persist!(page)
        services.persist_page.call(
          page: page,
          attributes: page_params
        )
      end

      def resources
        services.get_model_scopes.call[:page]
      end
    end
  end
end
