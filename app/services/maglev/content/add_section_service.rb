# frozen_string_literal: true

module Maglev
  module Content
    class AddSectionService
      include Injectable
      include Maglev::Content::HelpersConcern

      dependency :fetch_theme
      dependency :fetch_site

      argument :page
      argument :section_type
      argument :position, default: -1

      def call
        raise Maglev::Errors::UnknownSection unless section_definition

        section_content = build_section_content

        ActiveRecord::Base.transaction do
          add_to_site!(section_content) if can_add_to_site?
          add_to_page!(section_content) if can_add_to_page?
        end

        section_content
      end

      private

      def add_to_site!(section_content)
        # we don't care about the position for site scoped sections
        site.sections_translations_will_change!

        site.sections ||= []
        site.sections.push(section_content)
        site.prepare_sections(theme)

        site.save!
      end

      def add_to_page!(section_content)
        page.sections_translations_will_change!
        page.sections ||= []
        page.sections.insert(final_position, section_content)
        page.prepare_sections(theme)
        page.save!
      end

      def can_add_to_site?
        # We don't want to add the section if there is already a section with the same type
        site_scoped? && site.find_sections_by_type(section_type).empty?
      end

      def can_add_to_page?
        # we don't want to add the section if it's a singleton and there is already a section with the same type
        !(section_definition.singleton? && page.find_sections_by_type(section_type).any?)
      end

      def build_section_content
        if site_scoped? && site.find_sections_by_type(section_type).any?
          site.find_sections_by_type(section_type).first.dup.tap do |section|
            section['id'] = SecureRandom.urlsafe_base64(8)
          end
        else
          section_definition.build_default_content
        end.with_indifferent_access
      end

      def section_definition
        @section_definition ||= theme.sections.find(section_type)
      end

      def final_position
        case section_definition.insert_at
        when 'top' then 0
        when 'bottom' then page.sections.count - 1
        else
          position
        end
      end
    end
  end
end
