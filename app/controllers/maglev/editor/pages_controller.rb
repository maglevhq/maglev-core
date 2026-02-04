# frozen_string_literal: true

module Maglev
  module Editor
    class PagesController < Maglev::Editor::BaseController
      include ::Pagy::Backend

      before_action :set_page, only: %i[edit update destroy]
      before_action :maglev_disable_turbo_cache, only: %i[edit update new create]

      helper_method :query_params

      def index
        @pages = fetch_pages
        @pagy, @pages = pagy(@pages, limit: per_page) if pagination_enabled?
      end

      def new
        @page = maglev_page_resources.build
      end

      def edit
        # we need to store the active tab in the flash
        # because we can't pass the anchor to the redirect
        @active_tab = flash[:active_tab]
      end

      def create
        @page = maglev_services.create_page.call(attributes: page_params)
        if @page.persisted?
          redirect_to editor_real_root_path(maglev_editing_route_context(page: @page)), status: :see_other
        else
          flash.now[:alert] = flash_t(:error)
          render :new, status: :unprocessable_content
        end
      end

      def update
        if @page.update(page_params)
          flash[:active_tab] = params[:active_tab]
          redirect_to edit_editor_page_path(@page, **query_params, **maglev_editing_route_context),
                      notice: flash_t(:success), status: :see_other
        else
          flash.now[:alert] = flash_t(:error)
          render :edit, status: :unprocessable_content
        end
      end

      def destroy
        @page.destroy!
        redirect_to editor_pages_path(**query_params, **maglev_editing_route_context(page: maglev_home_page)),
                    notice: flash_t(:success), status: :see_other
      end

      private

      def set_page
        @page = maglev_page_resources.find(params[:id])
      end

      def build_page_resource
        maglev_page_resources.build(page_params)
      end

      def page_params
        params.require(:page).permit(:title, :path,
                                     :seo_title, :meta_description,
                                     :og_title, :og_description, :og_image_url,
                                     :visible, :lock_version)
      end

      def query_params(from_list: false)
        base = { q: params[:q], from_list: params[:from_list] || from_list }
        (pagination_enabled? ? base.merge(page: params[:page]) : base).compact_blank
      end

      def fetch_pages
        services.search_pages.call(
          q: params[:q],
          content_locale: content_locale,
          default_locale: default_content_locale,
          with_static_pages: false,
          index_first: true
        )
      end

      def pagination_enabled?
        per_page.present?
      end

      def per_page
        limit = maglev_config.pagination&.dig(:pages)
        limit == -1 ? nil : limit
      end
    end
  end
end
