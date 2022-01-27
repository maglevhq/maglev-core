# frozen_string_literal: true

module Maglev
  # Editors might want to create a link to a non Maglev powered page of the site.
  class FetchStaticPages
    include Injectable

    dependency :config

    def call
      return [] if config.static_pages.blank?

      build_static_pages
    end

    protected

    def build_static_pages
      @build_static_pages ||= config.static_pages.map do |raw_attributes|
        build_static_page(raw_attributes.symbolize_keys)
      end
    end

    def build_static_page(attributes)
      Maglev::StaticPage.new(
        id: fetch_id(attributes),
        title_translations: fetch_attribute(attributes, :title),
        path_translations: fetch_path_attribute(attributes),
        seo_title_translations: {},
        meta_description_translations: {},
        og_title_translations: {},
        og_description_translations: {},
        og_image_url_translations: {}
      )
    end

    def fetch_id(attributes)
      Digest::MD5.hexdigest(fetch_path_attribute(attributes).to_json)
    end

    def fetch_path_attribute(attributes)
      fetch_attribute(attributes, :path)
    end

    def fetch_attribute(attributes, name)
      value = attributes[name]
      return {} if value.blank?

      value.is_a?(Hash) ? value.stringify_keys : { default_locale => value }
    end

    def default_locale
      (config.default_site_locales&.first&.prefix || Maglev::I18n.current_locale).to_s
    end
  end
end
