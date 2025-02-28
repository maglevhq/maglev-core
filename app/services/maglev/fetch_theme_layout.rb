# frozen_string_literal: true

module Maglev
  # Return the path of the layout folder
  class FetchThemeLayout
    include Injectable

    dependency :fetch_theme

    argument :page

    def call
      'theme/layout'
    end
  end
end
