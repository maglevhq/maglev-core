# frozen_string_literal: true

# frozen_string_literal

module Maglev
  class FetchTheme
    include Injectable

    def call
      Maglev.theme
    end
  end
end
