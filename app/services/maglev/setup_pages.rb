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
      theme&.pages&.map do |page_attributes|
        persist_page.call(
          site: site,
          site_attributes: site_attributes_from(page_attributes),
          theme: theme,
          page: Maglev::Page.new,
          page_attributes: page_attributes
        )
      end
    end

    private

    def site_attributes_from(page_attributes)
      {
        sections: (page_attributes[:sections] || []).find_all do |section|
          definition = theme.sections.find(section['type'])
          definition.site_scoped?
        end
      }
    end
  end
end
