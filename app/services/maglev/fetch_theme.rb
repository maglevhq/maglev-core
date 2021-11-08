# frozen_string_literal: true

module Maglev
  # Fetch the current theme
  class FetchTheme
    include Injectable

    def call
      Maglev.local_themes.first
    end
  end
end
