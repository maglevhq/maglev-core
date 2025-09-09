# frozen_string_literal: true

module Maglev
  module Editor
    class LinksController < Maglev::Editor::BaseController
      before_action :ensure_turbo_frame_request, only: [:edit]
      before_action :set_link
      before_action :set_page
      before_action :set_sections

      layout false

      helper_method :input_id

      def edit
      end

      def update
        # some inputs are displayed based on the value of other inputs
        if params[:refresh] == '1' || !@link.valid?
          flash.now[:error] = flash_t(:error) unless @link.valid?
          render :edit, status: :unprocessable_entity
        end
      end

      private

      def set_link
        @link = Maglev::Content::EditorLink.new(link_params)
      end

      def set_page
        return unless @link.link_id
        @page = page_resources.find(@link.link_id)
      end

      def set_sections
        return unless @page
        @sections = services.get_page_section_names.call(page: @page)
      end

      def link_params
        params.require(:link).permit(:link_type, :link_id, :url_href, :email, :href, :section_id, :open_new_window)
      end

      def input_id
        params[:input_name].parameterize.underscore
      end

      def page_resources
        ::Maglev::Page
      end
    end
  end
end