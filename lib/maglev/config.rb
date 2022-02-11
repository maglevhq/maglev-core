# frozen_string_literal: true

module Maglev
  Config = Struct.new(:primary_color, :title, :favicon, :logo, :back_action,
                      :uploader, :asset_host, :services,
                      :collections, :is_authenticated, :ui_locale, :default_site_locales,
                      :static_pages, :reserved_paths,
                      :admin_username, :admin_password)
end
