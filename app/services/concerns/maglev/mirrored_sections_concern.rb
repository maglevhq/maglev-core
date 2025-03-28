# frozen_string_literal: true

# It requires the parent class to implement 2 methods:
# - scoped_pages
# - find_store
module Maglev
  module MirroredSectionsConcern
    private

    def persist_mirrored_sections(sections_content)
      sections_content.map { |group| group['sections'] }.flatten.find do |section|
        next unless section.dig('mirror_of', 'enabled')

        persist_mirror_section(section.except('mirror_of'), section['mirror_of'])
      end
    end

    def persist_mirror_section(section, mirror_of)
      store = find_store_from_mirrored_section(mirror_of)
      mirror_section = store.update_section_content(mirror_of['section_id'], section)
      store.save

      # is the mirror section a mirrored section too?!
      return unless mirror_section&.dig('mirror_of', 'enabled')

      # No need to detect a circular dependency because this is impossible
      # to change the mirror_of attributes of an existing section in the editor
      persist_mirror_section(mirror_section.except('mirror_of'), mirror_section['mirror_of'])
    end

    def find_store_from_mirrored_section(mirror_of)
      other_page = scoped_pages.find_by(id: mirror_of['page_id'])
      return unless other_page

      layout = fetch_layout(other_page.layout_id)
      layout_group = layout.groups.find { |group| group.id == mirror_of['layout_group_id'] }
      return unless layout_group

      find_store(layout_group.guess_store_handle(other_page))
    end

    def find_section_from_mirrored_section(mirror_of)
      store = find_store_from_mirrored_section(mirror_of)
      return unless store

      store.find_section(mirror_of['section_id'])
    end
  end
end
