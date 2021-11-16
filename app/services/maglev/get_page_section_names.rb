# frozen_string_literal: true

module Maglev
  # Get an array of maps including the id and name of each page section.
  class GetPageSectionNames
    include Injectable

    dependency :fetch_theme

    argument :page

    def call
      (page.sections || []).map do |section|
        definition = theme.sections.find(section['type'])
        { id: section['id'], name: definition.name }
      end
    end

    protected

    def theme
      fetch_theme.call
    end
  end
end
