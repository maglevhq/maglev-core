# frozen_string_literal: true

module Maglev
  # Retrieve a page from a path and a locale
  # (previously extracted by the ExtractLocale service)
  class FetchPage
    include Injectable

    dependency :context

    argument :path
    argument :locale
    argument :default_locale
    argument :fallback_to_default_locale, default: false
    argument :only_visible, default: false

    def call
      page = fetch_page(path, locale)
      page = fetch_page(path, default_locale) if !page && fallback_to_default_locale
      page
    end

    protected

    def fetch_page(path, locale)
      page = pages.by_path(path || 'index', locale).first
      !only_visible || (page&.visible? && only_visible) ? page : nil
    end

    def pages
      Maglev::Page
    end
  end
end
