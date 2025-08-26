# frozen_string_literal: true

module Maglev
  module Editor
    class PagesController < Maglev::Editor::BaseController
      before_action :set_page, only: %i[edit update destroy]
      before_action :maglev_disable_turbo_cache, only: %i[edit update new create]

      helper_method :query_params

      def index
        @pages = services.search_pages.call(q: params[:q], content_locale: content_locale,
                                            default_locale: default_content_locale,
                                            with_static_pages: false,
                                            index_first: true)
      end

      def new
        @page = resources.build
      end

      def edit
        @active_tab = flash[:active_tab] # we need to store the active tab in the flash because we can't pass the anchor to the redirect
      end

      def create
        @page = resources.build(page_params)
        if @page.save
          redirect_to editor_real_root_path(maglev_editing_route_context(page: @page)), status: :see_other
        else
          flash.now[:error] = flash_t(:error)
          render :new, status: :unprocessable_entity
        end
      end

      def update
        if @page.update(page_params)
          flash[:active_tab] = params[:active_tab]
          redirect_to edit_editor_page_path(@page, **query_params, **maglev_editing_route_context),
                      notice: flash_t(:success), status: :see_other
        else
          flash.now[:error] = flash_t(:error)
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @page.destroy!
        redirect_to editor_pages_path(query_params), notice: flash_t(:success), status: :see_other
      end

      private

      def set_page
        @page = resources.find(params[:id])
      end

      def page_params
        params.require(:page).permit(:title, :path,
                                     :seo_title, :meta_description,
                                     :og_title, :og_description, :og_image_url,
                                     :visible, :lock_version)
      end

      def query_params(from_list: false)
        { q: params[:q], from_list: params[:from_list] || from_list }.compact_blank
      end

      def resources
        ::Maglev::Page
      end
    end
  end
end
