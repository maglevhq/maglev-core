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

    # Build a path from a base url (optional) and a list of segments.
    # Segments are stripped from their leading/trailing slashes so that
    # a stored path such as "/hello-world" doesn't end up as "//hello-world".
    # The result never contains "//" (except for the scheme of the base url)
    # and always starts with a single "/" when there is no base url.
    def self.join(base_url, *segments)
      root = base_url.to_s.sub(%r{/+\z}, '')
      segments = segments.map { |segment| normalize_segment(segment) }.compact_blank
      [root, *segments].join('/').presence || '/'
    end

    def self.normalize_segment(segment)
      segment.to_s.gsub(%r{\A/+|/+\z}, '').gsub(%r{/{2,}}, '/')
    end

    def call
      base_url = get_base_url.call(preview_mode: preview_mode)
      safe_path = path || fetch_path

      return unless safe_path

      build_fullpath(base_url, safe_path)
    end

    protected

    def fetch_path
      paths = if page.respond_to?(:path_translations)
                # static pages already have all the translated paths
                page.path_translations.stringify_keys
              else
                # we need to request the DB to get the paths in all the locales
                fetch_paths
              end

      paths[locale.to_s] || paths[default_locale.to_s]
    end

    def fetch_paths
      page.respond_to?(:path_hash) ? page.path_hash : Maglev::PagePath.canonical_value_hash(page)
    end

    def build_fullpath(base_url, path)
      segments = []
      segments.push(locale) if prefix_by_default_locale?
      segments.push(path) unless self.class.normalize_segment(path) == 'index' # for SEO purpose
      self.class.join(base_url, *segments)
    end

    def site
      @site ||= fetch_site.call
    end

    def prefix_by_default_locale?
      !same_as_default_locale?
    end

    def same_as_default_locale?
      locale.to_s == default_locale.to_s
    end

    def default_locale
      site.default_locale.prefix
    end
  end
end
