# frozen_string_literal: true

module Maglev
  class GetPageFullpath
    include Injectable

    dependency :fetch_site
    dependency :get_base_url

    argument :page
    argument :preview_mode, default: nil
    argument :locale

    def call
      base_url = get_base_url.call(preview_mode: preview_mode)

      path = page.respond_to?(:path) ? (page.path || page.default_path) : ::Maglev::Page.find_by(id: page).try(:path)

      return unless path

      build_fullpath(base_url, path)

      # path = nil if path == 'index' # SEO purpose

      # fullpath = [base_url]
      # fullpath.push(locale) unless same_as_default_locale?
      # fullpath.push(path) unless path === 'index' # for SEO purpose


      # # TODO: how to pass the locale....?
      # # raise ['TODO', Translatable.current_locale, default_locale, locale.to_sym == default_locale.to_sym].inspect

      # locale.to_sym == default_locale.to_sym ? "#{base_url}/#{path}" : "#{base_url}/#{locale}/#{path}"
    end

    private

    def build_fullpath(base_url, path)
      fullpath = [base_url]
      fullpath.push(locale) unless same_as_default_locale?
      fullpath.push(path) unless path === 'index' # for SEO purpose
      fullpath.join('/')
    end

    def site
      @current_site ||= fetch_site.call
    end

    def same_as_default_locale?
      locale.to_s == default_locale.to_s
    end

    def default_locale
      site.default_locale.prefix
    end
  end
end
