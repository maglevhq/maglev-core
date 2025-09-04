# frozen_string_literal: true

module Maglev
  module Content
    class UpdateSectionService
      include Injectable

      dependency :fetch_theme
      dependency :fetch_site

      argument :page
      argument :section
      argument :content

      def call
        raise Maglev::Errors::UnknownSection unless section_definition

        ActiveRecord::Base.transaction do
          update_section_content!(site) if site_scoped?
          update_section_content!(page)
        end
      end

      private

      def update_section_content!(source)
        source.sections_translations_will_change!
        update_section_content(source)
        source.save!
      end

      def update_section_content(source)
        current_section_content = fetch_section_content(source)

        section.settings.each do |setting|
          next unless content.key?(setting.id.to_sym)

          update_section_setting_value(setting, current_section_content)
        end
      end

      def fetch_section_content(source)
        source.sections.find { |s| s['id'] == section.id }['settings']
      end

      def update_section_setting_value(setting, current_section_content)
        setting_content = current_section_content.find { |s| s['id'] == setting.id }
        setting_content['value'] = content[setting.id.to_sym]
      end

      def section_definition
        theme.sections.find(section.type)
      end

      def site_scoped?
        section_definition.site_scoped?
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
