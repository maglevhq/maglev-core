# frozen_string_literal: true

module Maglev
  module Content
    class AddSectionBlockService
      include Injectable
      include Maglev::Content::HelpersConcern

      dependency :fetch_theme
      dependency :fetch_site

      argument :page
      argument :section_id
      argument :block_type
      argument :parent_id, default: nil

      def call
        raise Maglev::Errors::UnknownSection unless section_definition

        block_content = build_block_content

        ActiveRecord::Base.transaction do
          add_to_section!(site, block_content) if section_definition.site_scoped?
          add_to_section!(page, block_content)
        end

        block_content
      end

      private

      def build_block_content
        section_definition.build_block_content_for(block_type).tap do |block_content|
          block_content[:parent_id] = parent_id if parent_id.present?
        end
      end

      def add_to_section!(source, block_content)
        source.sections_translations_will_change!
        section = source.find_section_by_id(section_id)
        section['blocks'] ||= []
        section['blocks'].push(block_content)
        source.save!
      end
    end
  end
end
