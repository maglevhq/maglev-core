# frozen_string_literal: true

module Maglev
  # Get the full path of a page (locale + path).
  # It relies on the GetBaseUrl service to get the base url.
  class GetPageFullpath
    include Injectable

    dependency :fetch_site
    dependency :get_base_url

    argument :page, default: nil
    argument :path, default: nil
    argument :preview_mode, default: nil
    argument :locale

    def call
      base_url = get_base_url.call(preview_mode: preview_mode)
      safe_path = path || fetch_path

      return unless safe_path

      build_fullpath(base_url, safe_path)
    end

    protected

    def fetch_path
      page_id = page.respond_to?(:path) ? page.id : page
      paths = Maglev::PagePath.build_hash(page_id)
      paths[locale.to_s] || paths[default_locale.to_s]
    end

    def build_fullpath(base_url, path)
      fullpath = [base_url]
      fullpath.push(locale) unless same_as_default_locale?
      fullpath.push(path) unless path == 'index' # for SEO purpose)
      fullpath.push(nil) if fullpath == [nil] # avoid "" as the fullpath
      fullpath.join('/')
    end

    def site
      @site ||= fetch_site.call
    end

    def same_as_default_locale?
      locale.to_s == default_locale.to_s
    end

    def default_locale
      site.default_locale.prefix
    end
  end
end
