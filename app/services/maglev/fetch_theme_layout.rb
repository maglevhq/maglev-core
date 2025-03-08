# frozen_string_literal: true

module Maglev
  # Return the path of the layout folder
  class FetchThemeLayout
    include Injectable

    dependency :fetch_theme

    argument :page

    def call
      return 'theme/layout' if page.layout_id.blank?

      "theme/layouts/#{page.layout_id}"
    end
  end
end
