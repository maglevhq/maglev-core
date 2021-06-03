# frozen_string_literal: true

module Maglev
  class GetPageFullpath
    include Injectable

    dependency :fetch_site
    dependency :get_base_url

    argument :page

    def call
      base_url = get_base_url.call

      path = page.respond_to?(:path) ? page.path : ::Maglev::Page.where(id: page).pick(:path)

      return unless path

      "#{base_url}/#{path}"
    end
  end
end
