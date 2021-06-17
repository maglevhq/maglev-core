# frozen_string_literal: true

module Maglev
  class FetchThemeLayout
    include Injectable

    dependency :fetch_theme

    def call
      'theme/layout'
    end
  end
end
