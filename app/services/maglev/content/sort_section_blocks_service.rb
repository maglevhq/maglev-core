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

      def call
        raise Maglev::Errors::UnknownSection unless section_definition

        ActiveRecord::Base.transaction do
          sort_section_blocks!(site) if site_scoped?
          sort_section_blocks!(page)
        end
      end

      private

      def sort_section_blocks!(source)
        source.sections_translations_will_change!
        sort_section_blocks(source)
        source.save!
      end

      def sort_section_blocks(source)
        find_blocks(source).sort_by! { |block| block_ids.index(block['id']) }
      end
    end
  end
end
