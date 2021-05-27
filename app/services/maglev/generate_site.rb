# frozen_string_literal: true

module Maglev
  class GenerateSite
    include Injectable

    dependency :fetch_theme
    dependency :setup_pages

    def call
      raise 'A Maglev Site exists already' if Maglev::Site.first

      Maglev::Site.transaction do
        Maglev::Site.create(name: 'Default').tap do
          setup_pages.call(theme: theme)
        end
      end
    end

    protected

    def theme
      fetch_theme.call
    end
  end
end
