# frozen_string_literal: true

module Maglev
  module Content
    class SortSectionsService
      include Injectable

      dependency :fetch_theme
      dependency :fetch_site

      argument :page
      argument :section_ids
      argument :lock_version, default: nil

      def call
        check_lock_version!
        sort_sections!
      end

      private

      def sort_sections!
        sorted_ids = normalized_section_ids
        page.sections_translations_will_change!
        page.sections.sort! { |a, b| sorted_ids.index(a['id']) <=> sorted_ids.index(b['id']) }
        page.save!
      end

      def check_lock_version!
        return if lock_version.blank?

        current_version = page.lock_version.to_i
        page.lock_version = lock_version.to_i

        return if current_version == lock_version.to_i

        raise ActiveRecord::StaleObjectError.new(page, 'sort_sections')
      end

      def normalized_section_ids
        # For site-scoped sections, transform_if_site_scoped replaces the page-local ID
        # with the site section's ID at render time, so the client sends site IDs.
        # Legacy pages (created before IDs were unified) store a different page-local ID.
        # Build a mapping: display_id (what the client sends) → page_id (what page.sections stores).
        id_map = page.sections.each_with_object({}) do |page_section, map|
          display_id = site_display_id_for(page_section) || page_section['id']
          map[display_id] = page_section['id']
        end
        section_ids.map { |id| id_map[id] || id }
      end

      def site_display_id_for(page_section)
        return unless theme.sections.find(page_section['type'])&.site_scoped?

        site.find_section(page_section['type'])&.dig('id')
      end

      def theme
        @theme ||= fetch_theme.call
      end

      def site
        @site ||= fetch_site.call
      end
    end
  end
end
