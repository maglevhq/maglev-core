# frozen_string_literal: true

module Maglev
  class GetBaseUrl
    include Injectable

    dependency :controller
    dependency :fetch_site

    def call
      preview_mode? ? site_preview_path : nil
    end

    private

    def preview_mode?
      controller.preview_mode?
    end

    def site_preview_path
      controller.site_preview_path
    end
  end
end
