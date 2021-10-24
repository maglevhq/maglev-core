# frozen_string_literal: true

module Maglev
  # Create the default pages of the theme. 
  # Called by the GenerateSite service.
  class SetupPages
    include Injectable

    dependency :persist_page, class: Maglev::PersistPage

    argument :site
    argument :theme

    def call
      theme&.pages&.map do |attributes|
        persist_page.call(
          site: site,
          theme: theme,
          page: Maglev::Page.new,
          attributes: attributes
        )
      end
    end
  end
end
