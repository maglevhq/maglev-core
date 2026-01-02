# frozen_string_literal: true

module Maglev
  module Content
    class UnlinkMirroredSectionService
      include Injectable
      include Maglev::Content::HelpersConcern

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
        source_store = fetch_mirrored_store(find_section['mirror_of'].symbolize_keys)
        original_section = find_section(source_store)

        target_section = store.find_section_by_id(section_id)

        target_section.dig('mirror_of')['enabled'] = false
        
        store.replace_section_content(target_section, original_section)
        
        store.save!
      end      
    end
  end
end
