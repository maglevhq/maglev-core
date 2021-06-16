# frozen_string_literal: true

# frozen_string_literal

module Maglev
  class FetchTheme
    include Injectable

    def call
      Maglev.local_themes.first
    end
  end
end
