# frozen_string_literal: true

module Maglev
  module Content
    class SortSectionBlocksService
      include Injectable
      include Maglev::Content::HelpersConcern

      dependency :fetch_theme
      dependency :fetch_site

      argument :page
      argument :section_id
      argument :block_ids
      argument :parent_id, default: nil
      argument :lock_version, default: nil

      def call
        raise Maglev::Errors::UnknownSection unless section_definition

        ActiveRecord::Base.transaction do
          sort_section_blocks!(site) if site_scoped?
          sort_section_blocks!(page)
        end
      end

      private

      def sort_section_blocks!(source)
        check_section_lock_version!(source)

        source.sections_translations_will_change!
        sort_section_blocks(source)
        source.save!
      end

      def sort_section_blocks(source)
        find_blocks(source)&.sort_by! do |block|
          block['parent_id'] == parent_id ? block_ids.index(block['id']) || Float::INFINITY : -1
        end
      end
    end
  end
end
