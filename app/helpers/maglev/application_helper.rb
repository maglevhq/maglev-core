# frozen_string_literal: true

require 'vite_rails/version'
require 'vite_rails/tag_helpers'

module Maglev
  module ApplicationHelper
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
