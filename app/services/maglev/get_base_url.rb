# frozen_string_literal: true

module Maglev
  class GetBaseUrl
    include Injectable

    dependency :context
    dependency :fetch_site

    def call
      preview_mode? ? site_preview_path : nil
    end

    private

    def preview_mode?
      context.preview_mode?
    end

    def site_preview_path
      context.controller.site_preview_path
    end
  end
end
