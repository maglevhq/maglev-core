# frozen_string_literal: true

module Maglev
  module Content
    class DeleteSectionBlockService
      include Injectable
      include Maglev::Content::HelpersConcern

      dependency :fetch_theme
      dependency :fetch_site

      argument :page
      argument :section_id
      argument :block_id
      argument :lock_version, default: nil

      def call
        raise Maglev::Errors::UnknownSection unless section_definition
        raise Maglev::Errors::UnknownBlock unless block_definition

        ActiveRecord::Base.transaction do
          if site_scoped?
            delete_section_block!(site)
          else
            delete_section_block!(page)
          end
        end
      end

      private

      def delete_section_block!(source)
        check_section_lock_version!(source)

        source.sections_translations_will_change!
        delete_section_block(source)
        source.save!
      end

      def delete_section_block(source)
        find_blocks(source).delete_if { |block| block['id'] == block_id }
      end
    end
  end
end
