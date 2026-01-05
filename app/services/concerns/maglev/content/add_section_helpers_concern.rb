# frozen_string_literal: true

module Maglev
  module Content
    module AddSectionHelpersConcern
      private

      def build_section_content
        if mirror_of.present?
          build_section_content_from_mirror_of
        elsif site_scoped? && site_scoped_store.find_sections_by_type(section_type).any?
          build_section_content_from_site_scoped_store
        else
          content || section_definition.build_default_content
        end.with_indifferent_access
      end

      def build_section_content_from_mirror_of
        fetch_mirrored_store(mirror_of).find_section_by_id(mirror_of[:section_id])
      end

      def build_section_content_from_site_scoped_store
        site_scoped_store.find_sections_by_type(section_type).first.dup
      end

      def final_position
        case section_definition.insert_at
        when 'top' then 0
        when 'bottom' then store.sections.count
        else
          position
        end
      end
    end
  end
end
