# frozen_string_literal: true

module Maglev
  # Get the content of a page in a specific locale.
  # Also replace the links by their real values based on the context (live editing or not).
  class GetPageSections
    include Injectable
    include Maglev::GetPageSections::TransformSectionConcern

    dependency :fetch_theme
    dependency :fetch_sections_content

    argument :page    
    argument :published, default: false
    argument :section_id, default: nil
    argument :locale, default: nil
    
    def call
      layout.groups.map do |group|
        sections, lock_version = fetch_sections(group)
        {
          id: group.id,
          sections: filter_sections(sections),
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

    def filter_sections(sections)
      sections.select do |section|
        # ignore deleted sections AND sections other than the one requested (ONLY WHEN section_id is provided)
        (section['deleted'].nil? || !section['deleted']) && (section_id.blank? || section['id'] == section_id)
      end
    end

    def fetch_sections(group)
      fetch_sections_content.call(
        handle: group.id,
        page: group.page_scoped? ? page : nil,
        published: published,
        locale: locale
      )
    end
  end
end