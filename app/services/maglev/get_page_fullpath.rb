# frozen_string_literal: true

module Maglev
  class GetPageFullpath
    include Injectable

    dependency :fetch_site
    dependency :get_base_url

    argument :page
    argument :preview_mode, default: nil

    def call
      base_url = get_base_url.call(preview_mode: preview_mode)

      path = page.respond_to?(:path) ? page.path : ::Maglev::Page.find_by(id: page).try(:path)

      return unless path

      "#{base_url}/#{path}"
    end
  end
end
