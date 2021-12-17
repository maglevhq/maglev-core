# frozen_string_literal: true

module Maglev
  module API
    class PagesController < ::Maglev::APIController
      def index
        @pages = services.search_pages.call(q: params[:q], content_locale: content_locale, default_locale: default_content_locale)
      end

      def show
        @page = services.search_pages.call(id: params[:id], content_locale: content_locale, default_locale: default_content_locale)
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
        params.require(:page).permit(:title, :path,
                                     :seo_title, :meta_description,
                                     :og_title, :og_description, :og_image_url,
                                     :visible, :lock_version).tap do |whitelisted|
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
        ::Maglev::Page
      end
    end
  end
end
