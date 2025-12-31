# frozen_string_literal: true

module Maglev
  module Content
    class AddSectionService
      include Injectable
      include Maglev::Content::HelpersConcern

      dependency :fetch_theme
      dependency :fetch_site

      argument :store
      argument :section_type
      argument :content, default: nil
      argument :position, default: -1
      argument :layout_id, default: nil # only used to recover a deleted section
      argument :mirror_of, default: nil # only used to add a mirrored section (attributes: page_id, layout_store_id, section_id)
      argument :dry_run, default: false
      argument :site, default: nil
      argument :theme, default: nil

      def call
        raise Maglev::Errors::UnknownSection unless section_definition

        section_content = if mirror_of.present?
          add_mirrored_section
        elsif can_recover_deleted_section?
          recover_deleted_section 
        else
          add_brand_new_section
        end

        # in case the instance of the service is reused, we need to reset the memoization
        # this is the case for the setup_pages service
        reset_memoization

        section_content
      end

      private

      def theme
        @theme ||= fetch_theme.call
      end

      def site
        @site ||= fetch_site.call
      end

      def add_mirrored_section
        section_content = build_section_content
        section_content['mirror_of'] = mirror_of.merge(enabled: true)
        
        add_to_store!(section_content)
        
        section_content
      end

      def recover_deleted_section
        store.sections_translations_will_change!
        section_content = store.find_section_by_type(section_type)
        section_content.delete('deleted')
        store.save! unless dry_run

        section_content
      end

      def add_brand_new_section
        section_content = build_section_content

        ActiveRecord::Base.transaction do
          add_to_site_scoped_store!(section_content) if can_add_to_site_scoped_store?
          add_to_store!(section_content) if can_add_to_store?
        end

        section_content
      end

      def add_to_site_scoped_store!(section_content)
        # we don't care about the position for site scoped sections
        site_scoped_store.sections_translations_will_change!
        site_scoped_store.sections ||= []
        site_scoped_store.sections.push(section_content)
        site_scoped_store.prepare_sections(theme)

        site_scoped_store.save!
      end

      def add_to_store!(section_content)
        store.sections_translations_will_change!
        store.sections ||= []
        store.sections.insert(final_position, section_content)
        store.prepare_sections(theme)

        store.save! unless dry_run
      end

      def can_add_to_site_scoped_store?
        # We don't want to add the section to the site scoped store if there is already a section with the same type
        site_scoped? && site_scoped_store.find_sections_by_type(section_type).empty?
      end

      def can_add_to_store?
        # we don't want to add the section if it's a singleton and there is already a section with the same type
        !(section_definition.singleton? && store.find_sections_by_type(section_type).any?)
      end     
      
      def can_recover_deleted_section?
        # first, the section must be deleted in the store
        return false if store.find_section_by_type(section_type).nil? || store.find_section_by_type(section_type)['deleted'] != true

        # then, the section must be present in the "recoverable" list of the layout group        
        layout_group = theme.find_layout(layout_id)&.find_group(store.handle)

        layout_group && layout_group.recoverable?(section_definition)        
      end

      def build_section_content
        if mirror_of.present?
          fetch_mirrored_store(mirror_of).find_section_by_id(mirror_of[:section_id])
        elsif site_scoped? && site_scoped_store.find_sections_by_type(section_type).any?
          site_scoped_store.find_sections_by_type(section_type).first.dup
        else
          content || section_definition.build_default_content
        end.with_indifferent_access
      end

      def section_definition
        @section_definition ||= theme.sections.find(section_type)
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
