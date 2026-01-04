# frozen_string_literal: true

module Maglev
  module Content
    class UnlinkMirroredSectionService
      include Injectable
      include Maglev::Content::HelpersConcern
      include Maglev::Content::PublishingStateConcern

      dependency :fetch_theme
      dependency :fetch_site

      argument :store
      argument :section_id
      
      def call
        raise Maglev::Errors::UnknownSection unless section_definition

        ActiveRecord::Base.transaction do
          unsafe_call
        end
      end

      private

      def unsafe_call
        update_store_content!.tap { touch_page(store) }
      end   
      
      def update_store_content!
        target_section = store.find_section_by_id(section_id)
        target_section.dig('mirror_of')['enabled'] = false
        
        store.replace_section_content(target_section, fetch_source_section)
        store.save!
      end

      def fetch_source_section
        source_store = fetch_mirrored_store(find_section['mirror_of'].symbolize_keys)
        find_section(source_store)
      end
    end
  end
end
