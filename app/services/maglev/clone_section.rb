# frozen_string_literal: true

module Maglev
  class CloneSection
    include Injectable
    include Maglev::Content::PublishingStateConcern

    class NotCloneable < StandardError; end

    argument :store
    argument :section_id
    argument :theme
    argument :layout_id

    def call
      store.with_lock do
        original = store.find_section_by_id(section_id)
        raise ActiveRecord::RecordNotFound unless original

        definition = theme.sections.find(original.fetch('type'))
        group = theme.find_layout(layout_id).find_group(store.handle)
        raise NotCloneable unless definition&.can_be_added_in?(group, true)

        copy = source_content(original).deep_dup.except('mirror_of', 'lock_version', 'deleted')
        copy['id'] = SecureRandom.urlsafe_base64(8)
        blocks = copy.fetch('blocks', [])
        block_ids = blocks.to_h { |block| [block.fetch('id'), SecureRandom.urlsafe_base64(8)] }
        blocks.each do |block|
          block['id'] = block_ids.fetch(block['id'])
          block['parent_id'] = block_ids.fetch(block['parent_id']) if block['parent_id'].present?
          block.delete('lock_version')
        end

        store.sections_translations_will_change!
        store.sections.insert(store.position_of_section(section_id) + 1, copy)
        store.save!
        touch_page(store)
        copy
      end
    end

    private

    def source_content(section)
      visited = Set.new
      while section.dig('mirror_of', 'enabled')
        mirror = section.fetch('mirror_of')
        raise NotCloneable unless visited.add?(mirror)

        page = Maglev::Page.find(mirror.fetch('page_id'))
        handle = mirror['layout_store_id'] || mirror['layout_group_id']
        group = theme.find_layout(page.layout_id).find_group(handle)
        raise ActiveRecord::RecordNotFound unless group

        source_store = Maglev::SectionsContentStore.unpublished.find_by!(
          handle: group.handle, page: group.page_scoped? ? page : nil
        )
        section = source_store.find_section_by_id(mirror.fetch('section_id'))
        raise ActiveRecord::RecordNotFound unless section
      end
      section
    end
  end
end
