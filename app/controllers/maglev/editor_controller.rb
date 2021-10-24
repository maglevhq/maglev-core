# frozen_string_literal: true

module Maglev
  class EditorController < ApplicationController
    include Maglev::FetchersConcern
    include Maglev::BackActionConcern
    include Maglev::UiLocaleConcern
    include Maglev::ContentLocale

    before_action :set_content_locale

    helper_method :maglev_home_page_id

    def show
      fetch_maglev_page_content
      render layout: nil
    end

    def destroy
      call_back_action
    end

    private
    
    def maglev_home_page_id
      @maglev_home_page_id ||= ::Maglev::Page.home.pick(:id) || ::Maglev::Page.home(maglev_site.default_locale.prefix).pick(:id)
    end

    def fallback_to_default_locale
      true
    end
  end
end
