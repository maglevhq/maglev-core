# frozen_string_literal: true

module Maglev
  module Content
    class SortSectionBlocksService
      include Injectable
      include Maglev::Content::HelpersConcern
      include Maglev::Content::PublishingStateConcern

      dependency :fetch_theme
      dependency :fetch_site

      argument :store
      argument :section_id
      argument :block_ids
      argument :parent_id, default: nil
      argument :lock_version, default: nil

      def call
        raise Maglev::Errors::UnknownSection unless section_definition

        ActiveRecord::Base.transaction do
          unsafe_call
        end
      end

      private

      def unsafe_call
        if site_scoped?
          sort_section_blocks!(site_scoped_store)
        else
          sort_section_blocks!(store)
        end.tap { touch_page(store) }
      end

      def sort_section_blocks!(source)
        source.lock_version = lock_version if lock_version.present?

        source.sections_translations_will_change!
        sort_section_blocks(source)
        source.save!
      end

      # Only the siblings (the blocks sharing the same parent) are re-ordered, in place.
      # The other blocks keep their position in the flat list: sorting the whole list
      # with a non-stable sort (Array#sort_by!) used to shuffle the blocks outside of
      # the sorted scope, like the children of the other blocks in a tree.
      def sort_section_blocks(source)
        blocks = find_blocks(source)
        return if blocks.blank?

        indices = blocks.each_index.select { |index| sibling?(blocks[index]) }
        sorted_siblings = sort_siblings(blocks.values_at(*indices))

        indices.zip(sorted_siblings) { |index, block| blocks[index] = block }
      end

      def sort_siblings(siblings)
        siblings.sort_by.with_index do |block, position|
          [block_ids.index(block['id']) || Float::INFINITY, position]
        end
      end

      def sibling?(block)
        block['parent_id'].presence == parent_id.presence
      end
    end
  end
end
