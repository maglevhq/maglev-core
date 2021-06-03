# frozen_string_literal: true

# frozen_string_literal

module Maglev
  class FetchTheme
    include Injectable

    def call
      Maglev.local_themes.first.tap do |theme|
        theme.sections_path = 'theme'
      end
    end
  end
end
