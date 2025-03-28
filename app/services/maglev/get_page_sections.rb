# frozen_string_literal: true

module Maglev
  # Get the content of a page in a specific locale.
  # The content comes from the sections of the page.
  # Also replace the links by their real values based on the context (live editing or not).
  class GetPageSections
    include Injectable
    include Maglev::FetchSectionsContent::TransformSectionConcern

    dependency :fetch_theme
    dependency :fetch_sections_content

    argument :page
    argument :sections_content, default: nil
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
      theme.find_layout(page.layout_id).tap do |layout|
        raise Maglev::Errors::MissingLayout, "The page #{page.id} misses the layout_id property" if layout.nil?
      end
    end

    def fetch_sections(group)
      if sections_content
        fetch_local_sections(group)
      else
        fetch_stored_sections(group)
      end
    end

    def fetch_stored_sections(group)
      fetch_sections_content.call(
        handle: group.guess_store_handle(page),
        locale: locale
      )
    end

    def fetch_local_sections(layout_group)
      content_group = sections_content.find { |group| group['id'] == layout_group.id }

      return [[], 0] if content_group.blank?

      [
        content_group['sections'].map { |section| transform_section(section) },
        0
      ]
    end
  end
end
