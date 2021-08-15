# frozen_string_literal: true

module Maglev
  class FetchSectionsPath
    include Injectable

    argument :theme, default: nil

    def call
      'theme'
    end
  end
end
