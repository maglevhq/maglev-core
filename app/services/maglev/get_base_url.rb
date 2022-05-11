# frozen_string_literal: true

module Maglev
  # Get the url used to build the URLs of the pages.
  # In the preview mode, we need the maglev root path.
  class GetBaseUrl
    include Injectable

    dependency :context
    dependency :fetch_site

    argument :preview_mode, default: nil

    def call
      preview_mode? ? site_preview_path : live_url
    end

    private

    def preview_mode?
      preview_mode.nil? ? context.rendering_mode == :editor : preview_mode
    end

    def site_preview_path
      context.controller.site_preview_path
    end

    def live_url
      nil
    end
  end
end
