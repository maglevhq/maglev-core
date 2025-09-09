# frozen_string_literal: true

require 'vite_rails/version'
require 'vite_rails/tag_helpers'

# rubocop:disable Metrics/ModuleLength
module Maglev
  module ApplicationHelper
    def turbo_stream
      # we don't want to pollute the global Turbo::Streams::TagBuilder
      Maglev::Turbo::Streams::TagBuilder.new(self)
    end

    def maglev_editor_javascript_tags
      maglev_importmap_tags(:editor, 'editor')
    end

    def maglev_client_javascript_tags
      return '' unless maglev_rendering_mode == :editor

      maglev_importmap_tags(:client, 'client')
    end

    def maglev_importmap_tags(namespace, entry_point)
      safe_join [
        javascript_inline_importmap_tag(Maglev::Engine.importmaps[namespace].to_json(resolver: self)),
        javascript_importmap_module_preload_tags(Maglev::Engine.importmaps[namespace]),
        javascript_import_module_tag(entry_point)
      ], "\n"
    end

    def maglev_favicon_url
      case maglev_config.favicon
      when nil
        asset_path('maglev/favicon.svg')
      when String
        asset_path(maglev_config.favicon)
      when Proc
        instance_exec(maglev_site, &maglev_config.favicon)
      end
    end

    def maglev_primary_hex_color
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

    def maglev_primary_rgb_color
      maglev_primary_hex_color
        .gsub('#', '')
        .scan(/.{2}/)
        .map { |value| value.to_i(16) }
    end

    # UI helpers

    # rubocop:disable Metrics/MethodLength
    def maglev_button_classes(...)
      ClassVariants.build(
        base: 'rounded-xs transition-colors duration-200 text-center cursor-pointer',
        variants: {
          color: {
            primary: 'text-white bg-editor-primary/95 hover:bg-editor-primary/100 disabled:bg-editor-primary/75',
            secondary: 'text-gray-800 hover:bg-gray-100'
          },
          size: {
            big: 'flex items-center justify-center w-full px-6 py-4',
            medium: 'inline-flex items-center justify-center px-4 py-2'
          }
        },
        defaults: {
          color: :primary,
          size: :medium
        }
      ).render(...)
    end
    # rubocop:enable Metrics/MethodLength

    def maglev_icon_button_classes(...)
      ClassVariants.build(
        base: %(h-7 w-7 flex items-center justify-center rounded-full focus:outline-none
        transition-colors duration-200 cursor-pointer bg-gray-600/0 text-gray-800
        hover:bg-gray-600/10 hover:text-gray-900)
      ).render(...)
    end

    def maglev_flash_message
      message, color, icon_name = if flash[:notice].present?
                                    [flash[:notice], :green, 'checkbox_circle']
                                  elsif flash[:error].present?
                                    [flash[:error], :red, 'error_warning']
                                  end

      return '' if message.blank?

      render Maglev::Uikit::BadgeComponent.new(color: color,
                                               icon_name: icon_name,
                                               disappear_after: 3.seconds).with_content(message)
    end

    def maglev_page_icon(page, size: '1.15rem')
      icon_name = page.index? ? 'home' : 'file'
      render Maglev::Uikit::IconComponent.new(name: icon_name, size: size, class_names: 'shrink-0')
    end

    def maglev_page_preview_reload_data
      {
        controller: 'dispatcher',
        action: 'click->dispatcher#trigger',
        dispatcher_event_name_value: 'page-preview:reload'
      }
    end

    # [DEPRECATED]Vite Rails helpers
    include ::ViteRails::TagHelpers

    def vite_manifest
      use_engine_vite? ? maglev_asset_manifest : super
    end

    def maglev_live_preview_client_javascript_tag
      # rubocop:disable Layout/LineLength
      Rails.logger.warn '🚨 maglev_live_preview_client_javascript_tag is deprecated, use maglev_client_javascript_tags instead'
      # rubocop:enable Layout/LineLength
      maglev_client_javascript_tags
    end

    def legacy_live_preview_client_javascript_tag
      # no need to render the tag when the site is being visited outside the editor
      return '' unless maglev_rendering_mode == :editor

      entries = maglev_asset_manifest.resolve_entries(*%w[live-preview-rails-client], type: :javascript)

      javascript_include_tag(
        *entries.fetch(:scripts).flatten.uniq,
        crossorigin: 'anonymous',
        type: 'module',
        defer: true,
        nonce: true
      )
    end

    def maglev_asset_manifest
      ::Maglev::Engine.vite_ruby.manifest
    end
  end
end
# rubocop:enable Metrics/ModuleLength
