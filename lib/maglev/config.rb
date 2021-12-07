# frozen_string_literal: true

module Maglev
  Config = Struct.new(:primary_color, :title, :favicon, :logo, :back_action, :uploader, :services,
                      :collections, :is_authenticated, :ui_locale, :default_site_locales,
                      :admin_username, :admin_password)
end
