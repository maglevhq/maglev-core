# frozen_string_literal: true

module Maglev
  class EditorController < ApplicationController
    include Maglev::AuthenticationConcern
    include Maglev::FetchersConcern
    include Maglev::BackActionConcern
    include Maglev::UserInterfaceLocaleConcern
    include Maglev::ContentLocaleConcern

    before_action :fetch_maglev_site, only: :show
    before_action :ensure_path_and_content_locale, only: :show
    before_action :set_content_locale, only: :show

    helper_method :maglev_home_page_id

    def show
      fetch_maglev_page_content
      render layout: nil
    end

    def destroy
      call_back_action
    end

    private

    def ensure_path_and_content_locale
      return unless params[:path].blank? || params[:locale].blank?

      redirect_to default_maglev_editor_path
    end

    def maglev_home_page_id
      @maglev_home_page_id ||=
        maglev_pages_collection.home.pick(:id) ||
        maglev_pages_collection.home(default_content_locale).pick(:id)
    end

    def maglev_pages_collection
      ::Maglev::Page
    end

    def fallback_to_default_locale
      true
    end

    def maglev_rendering_mode
      :editor
    end

    def default_maglev_editor_path
      editor_path(
        params[:path] || 'index',
        locale: params[:locale] || default_content_locale
      )
    end
  end
end
