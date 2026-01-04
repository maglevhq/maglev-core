# frozen_string_literal: true

module Maglev
  module Content
    class AddSectionBlockService
      include Injectable
      include Maglev::Content::HelpersConcern
      include Maglev::Content::PublishingStateConcern

      dependency :fetch_theme
      dependency :fetch_site

      argument :store
      argument :section_id
      argument :block_type
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
        block_content = build_block_content

        if site_scoped?
          add_to_section!(site_scoped_store, block_content)
        else
          add_to_section!(store, block_content)
        end.tap { touch_page(store) }

        block_content
      end

      def build_block_content
        section_definition.build_block_content_for(block_type).tap do |block_content|
          block_content[:parent_id] = parent_id if parent_id.present?
        end
      end

      def add_to_section!(source, block_content)
        check_section_lock_version!(source)

        source.sections_translations_will_change!
        section = source.find_section_by_id(section_id)
        section['blocks'] ||= []
        section['blocks'].push(block_content)
        source.save!
      end
    end
  end
end
