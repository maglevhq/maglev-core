# frozen_string_literal: true

module Maglev
  module EditorHelper
    def site_editor_path
      editor_path
    end

    def site_leave_editor_path
      leave_editor_path
    end

    def api_base_path
      "#{root_path}api"
    end

    def editor_window_title
      maglev_config.title.presence || 'Maglev - EDITOR'
    end

    def editor_primary_hex_color
      color = maglev_config.primary_color
      if color =~ /^\#(\d)(\d)(\d)$/
        r_value = ''.rjust(2, Regexp.last_match(1))
        g_value = ''.rjust(2, Regexp.last_match(2))
        b_value = ''.rjust(2, Regexp.last_match(3))
        "##{r_value}#{g_value}#{b_value}"
      else
        color
      end
    end

    def editor_primary_rgb_color
      editor_primary_hex_color
        .gsub('#', '')
        .scan(/.{2}/)
        .map { |value| value.to_i(16) }
    end

    def editor_logo_url
      editor_asset_path(maglev_config.logo, 'logo.png')
    end

    def editor_favicon_url
      editor_asset_path(maglev_config.favicon, 'favicon.png')
    end

    def editor_asset_path(source, default_source)
      if source.blank?
        asset_path("maglev/#{default_source}")
      else
        ActionController::Base.helpers.asset_path(source)
      end
    end
  end
end
