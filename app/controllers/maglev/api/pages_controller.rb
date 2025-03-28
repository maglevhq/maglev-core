# frozen_string_literal: true

module Maglev
  module Api
    class PagesController < ::Maglev::ApiController
      def index
        @pages = services.search_pages.call(q: params[:q], content_locale: content_locale,
                                            default_locale: default_content_locale)
      end

      def show
        @page = services.search_pages.call(id: params[:id], content_locale: content_locale,
                                           default_locale: default_content_locale)
        head :not_found if @page.nil?
      end

      def create
        page = resources.create!(page_params)
        head :created, location: api_page_path(page)
      end

      def update
        page = resources.find(params[:id])
        page.update!(page_params)
        head :ok, page_lock_version: page.lock_version
      end

      def destroy
        resources.destroy(params[:id])
        head :no_content
      end

      private

      def page_params
        params.require(:page).permit(:title, :path, :layout_id,
                                     :seo_title, :meta_description,
                                     :og_title, :og_description, :og_image_url,
                                     :visible, :lock_version)
      end

      def resources
        ::Maglev::Page
      end
    end
  end
end
