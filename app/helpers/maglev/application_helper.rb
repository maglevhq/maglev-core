# frozen_string_literal: true

require 'webpacker/helper'

module Maglev
  module ApplicationHelper
    include ::Webpacker::Helper

    def current_webpacker_instance
      use_engine_webpacker? ? ::Maglev.webpacker : super
    end

    def maglev_live_preview_client_javascript_tag
      # no need to render the tag when the site is being visited outside the editor
      return '' unless maglev_rendering_mode == :editor

      javascript_include_tag(
        *%w(live-preview-rails-client).map do |name| 
          ::Maglev.webpacker.manifest.lookup_pack_with_chunks!(name.to_s, type: :javascript) 
        end.flatten.uniq
      )      
    end
  end
end
