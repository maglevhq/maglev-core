# frozen_string_literal: true

module Maglev
  class GenerateSite
    include Injectable

    dependency :setup_pages, class: Maglev::SetupPages

    def call
      raise 'A Maglev Site exists already' if Maglev::Site.first

      Maglev::Site.transaction do
        Maglev::Site.create(name: 'default').tap do
          setup_pages.call(theme: Maglev.theme)
        end
      end
    end
  end
end
