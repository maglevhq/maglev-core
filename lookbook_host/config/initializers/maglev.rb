# frozen_string_literal: true

Maglev.configure do |config|
  config.uploader = :active_storage
  # config.primary_color = '#674DCB'
end

Maglev.disable_theme_reloader
