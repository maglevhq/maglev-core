# It requires the parent class to implement 2 methods:
# - scoped_pages
# - find_store
module Maglev::MirroredSectionsConcern

  private

  def persist_mirrored_sections(sections_content)
    sections_content.map { |group| group['sections'] }.flatten.find do |section|
      next unless section.dig('mirror_of', 'enabled')
      persist_mirror_section(section.except('mirror_of'), section['mirror_of'])
    end
  end

  def persist_mirror_section(section, mirror_of)
    store = find_store_from_mirrored_section(mirror_of)
    store.update_section_content(mirror_of['section_id'], section)
    store.save
  end

  def find_store_from_mirrored_section(mirror_of)
    other_page = scoped_pages.find_by(id: mirror_of['page_id'])
    return unless other_page
    layout = fetch_layout(other_page.layout_id)
    group = layout.groups.find { |group| group.id == mirror_of['layout_group_id'] }
    return unless group
    find_store(group.guess_store_handle(other_page))
  end

  def find_section_from_mirrored_section(mirror_of)
    store = find_store_from_mirrored_section(mirror_of)
    return unless store
    store.find_section(mirror_of['section_id'])
  end
end