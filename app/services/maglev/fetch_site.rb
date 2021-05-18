# frozen_string_literal: true

module Maglev
  class FetchSite
    include Injectable

    def call
      Maglev::Site.first
    end
  end
end
