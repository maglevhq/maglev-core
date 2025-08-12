# frozen_string_literal: true

require 'vite_rails/version'
require 'vite_rails/tag_helpers'

module Maglev
  module ApplicationHelper
    def maglev_importmap_tags(entry_point = "editor")
      safe_join [
        javascript_inline_importmap_tag(Maglev::Engine.importmap.to_json(resolver: self)),
        javascript_importmap_module_preload_tags(Maglev::Engine.importmap),
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

    def maglev_button_classes(...)
      ClassVariants.build(
        base: 'rounded-sm px-6 py-4 transition-colors duration-200 text-white text-center cursor-pointer',
        variants: {
          color: {
            primary: 'bg-editor-primary/95 hover:bg-editor-primary/100 disabled:bg-editor-primary/75',
          },
          size: {
            big: 'flex items-center justify-center w-full'
          }
        }
      ).render(...)
    end

    # [DEPRECATED]Vite Rails helpers
    include ::ViteRails::TagHelpers

    def vite_manifest
      use_engine_vite? ? maglev_asset_manifest : super
    end

    def maglev_live_preview_client_javascript_tag
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
