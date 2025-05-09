# frozen_string_literal: true

module Maglev
  # Get the content of the global site scoped sections.
  # The content comes from the sections of the page.
  # Also replace the links by their real values based on the context (live editing or not).
  class GetSiteScopedSections
    include Injectable
    include Maglev::FetchSectionsContent::TransformSectionConcern

    dependency :fetch_site
    dependency :fetch_theme

    def call
      fetch_stored_sections.each_with_object({}) do |section, memo|
        memo[section['type']] = transform_section(section.dup)
      end
    end

    private

    def fetch_stored_sections
      scoped_stores.find_by(handle: Maglev::SectionsContentStore::SITE_HANDLE)&.sections || []
    end

    def scoped_stores
      Maglev::SectionsContentStore
    end

    def theme
      @theme ||= fetch_theme.call
    end
  end
end
