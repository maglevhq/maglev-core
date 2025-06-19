# frozen_string_literal: true

module Maglev
  module EditorHelper
    # Path to the editor but without the locale
    def site_base_editor_path
      base_editor_path
    end

    def site_editor_path
      editor_path(locale: maglev_site.default_locale)
    end

    def site_leave_editor_path
      leave_editor_path
    end

    def api_base_path
      api_root_path
    end

    def editor_window_title
      case maglev_config.title
      when nil
        'Maglev - EDITOR'
      when String
        maglev_config.title
      when Proc
        instance_exec(maglev_site, &maglev_config.title)
      end
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
      case maglev_config.logo
      when nil
        editor_asset_path(nil, 'logo.svg')
      when String
        editor_asset_path(maglev_config.logo, 'logo.svg')
      when Proc
        instance_exec(maglev_site, &maglev_config.logo)
      end
    end

    def editor_favicon_url
      case maglev_config.favicon
      when nil
        editor_asset_path(nil, 'favicon.svg')
      when String
        editor_asset_path(maglev_config.favicon, 'favicon.svg')
      when Proc
        instance_exec(maglev_site, &maglev_config.favicon)
      end
    end

    def editor_site_publishable
      !!maglev_config.site_publishable
    end

    def editor_asset_path(source, default_source)
      if source.blank?
        vite_asset_path("images/#{default_source}")
      elsif source =~ %r{^(https?://|/)}
        source
      else
        # rely on Sprockets by default
        ActionController::Base.helpers.asset_path(source)
      end
    end

    def editor_custom_translations
      I18n.available_locales.index_with do |locale|
        ::I18n.t('maglev', locale: locale, default: nil)
      end
    end
  end
end
