# frozen_string_literal: true

module Maglev
  DEFAULT_PAGINATION = { pages: -1, assets: 16 }.freeze

  Config = Struct.new(:primary_color, :title, :favicon, :logo, :back_action,
                      :site_publishable, :uploader, :preview_host, :asset_host, :services,
                      :collections, :is_authenticated, :ui_locale, :default_site_locales,
                      :static_pages, :reserved_paths,
                      :admin_username, :admin_password,
                      :tailwindcss_folders, :pagination) do
    # custom setter + helpers for the pagination config
    def pagination=(value)
      self[:pagination] = if value.is_a?(Hash)
                            ::Maglev::DEFAULT_PAGINATION.merge(value)
                          else
                            value
                          end
    end

    def pagination?(key)
      self[:pagination][key].present? && self[:pagination][key] != -1
    end

    def per_page(key)
      self[:pagination][key]
    end
  end
end
