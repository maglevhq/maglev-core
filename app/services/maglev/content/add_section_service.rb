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
          add_to_site!(section_content) if site_scoped?
          add_to_page!(section_content)
        end

        section_content
      end

      private

      def add_to_site!(section_content)
        site.sections_translations_will_change!
        # we don't care about the position for site scoped sections
        site.sections ||= []
        site.sections.push(section_content)
        site.prepare_sections(theme)

        site.save!
      end

      def add_to_page!(section_content)
        page.sections_translations_will_change!
        page.sections ||= []
        page.sections.insert(position, section_content)
        page.prepare_sections(theme)
        page.save!
      end

      def build_section_content
        section_definition.build_default_content.with_indifferent_access
      end

      def section_definition
        @section_definition ||= theme.sections.find(section_type)
      end
    end
  end
end
