# frozen_string_literal: true

module Maglev
  class FetchPage
    include Injectable

    argument :params
    argument :fallback_to_default_locale, default: false

    def call
      # raise 'TODO'
      # page = Maglev::Page.by_path(params[:path] || 'index', params[:locale]).first
      path, locale, default_locale = params[:path], params[:locale], params[:default_locale]
      page = fetch_page(path, locale)

      if !page && fallback_to_default_locale
        page = fetch_page(path, default_locale)
      end

      page
    end

    protected

    def fetch_page(path, locale)
      Maglev::Page.by_path(path || 'index', locale).first
    end
  end
end
