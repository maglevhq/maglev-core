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
        page = persist!(resources.new)
        head :created, location: api_page_path(page)
      end

      def destroy
        resources.destroy(params[:id])
        head :no_content
      end

      def update
        page = resources.find(params[:id])
        persist!(page)
        head :ok, page_lock_version: page.lock_version
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

      def site_params
        lock_version = params.dig(:site, :lock_version)
        sections = params[:site].to_unsafe_hash[:sections] unless params.dig(:site, :sections).nil?
        style = params.dig(:site, :style)
        (lock_version && sections ? { lock_version: lock_version, sections: sections } : {}).merge(style: style)
      end

      def persist!(page)
        services.persist_page.call(
          page: page,
          page_attributes: page_params,
          site: maglev_site,
          site_attributes: site_params
        )
      end

      def resources
        ::Maglev::Page
      end
    end
  end
end
