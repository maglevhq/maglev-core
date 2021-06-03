# frozen_string_literal: true

module Maglev
  class GetModelScopes
    include Injectable

    def call
      {
        site: Maglev::Site,
        page: Maglev::Page,
        asset: Maglev::Asset
      }
    end
  end
end
