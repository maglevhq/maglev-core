# frozen_string_literal: true

module Maglev
  module SiteConcern
    private

    def fetch_site
      @site = ::Maglev::Site.first
    end

    def fetch_page
      @page = Maglev::Page.where(path: params[:path] || 'index').first
    end

    def fetch_theme
      @theme = Maglev::Theme.default
    end
  end
end
