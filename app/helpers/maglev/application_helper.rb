# frozen_string_literal: true
require 'vite_rails/version'
require 'vite_rails/tag_helpers'

module Maglev
  module ApplicationHelper
    include ::ViteRails::TagHelpers

    def vite_manifest
      inside_engine? ? maglev_asset_manifest : super
    end

    def maglev_live_preview_client_javascript_tag
      # no need to render the tag when the site is being visited outside the editor
      return '' unless maglev_rendering_mode == :editor

      javascript_include_tag(
        *%w[live-preview-rails-client].map do |name|
          maglev_asset_manifest.lookup_pack_with_chunks!(name.to_s, type: :javascript)
        end.flatten.uniq
      )
    end

    def maglev_asset_manifest
      ::Maglev::Engine.vite_ruby.manifest
    end
  end
end
