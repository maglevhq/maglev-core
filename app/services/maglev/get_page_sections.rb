# frozen_string_literal: true

module Maglev
  # Get the content of a page in a specific locale.
  # The content comes from the sections of the page.
  # Also replace the links by their real values based on the context (live editing or not).
  class GetPageSections
    include Injectable

    dependency :fetch_theme
    dependency :fetch_sections_content

    argument :page
    argument :locale, default: nil

    def call
      layout.groups.map do |group|
        sections, lock_version = fetch_sections(group)
        {
          id: group.id,
          sections: sections,
          lock_version: lock_version
        }
      end
    end

    protected

    def theme
      @theme ||= fetch_theme.call
    end

    def layout
      theme.find_layout(page.layout_id)
    end

    def fetch_sections(group)
      fetch_sections_content.call(
        handle: group.guess_store_handle(page),
        locale: locale
      )
    end
  end
end
