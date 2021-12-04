# frozen_string_literal: true

module Maglev
  module API
    class PagesController < ::Maglev::APIController
      def index
        @pages = if params[:q]
                   resources.search(params[:q], content_locale)
                 else
                   resources.all
                 end
      end

      def show
        @page = find_by_id_or_path(params[:id])
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

      def find_by_id_or_path(id)
        resources.by_id_or_path(id).first ||
          resources.by_id_or_path(id, Maglev::I18n.default_locale).first
      end

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
