# frozen_string_literal: true

module Maglev
  module Editor
    class LinksController < Maglev::Editor::BaseController
      before_action :ensure_turbo_frame_request, only: [:edit]

      layout false

      def edit
        @link = Maglev::Content::EditorLink.new(link_params(:link))
      end

      def update
        @link = Maglev::Content::EditorLink.new(link_params)
        unless @link.valid?
          flash.now[:error] = flash_t(:error)
          render :edit, status: :unprocessable_entity
        end
      end

      private

      def link_params(key = :content_editor_link)
        params.require(key).permit(:link_type, :link_id, :url_href, :email_href, :href,:open_new_window)
      end
    end
  end
end