# frozen_string_literal: true

module Maglev
  module Content
    class UpdateSectionService
      include Injectable
      include Maglev::Content::HelpersConcern

      dependency :fetch_theme
      dependency :fetch_site

      argument :page
      argument :section_id
      argument :content
      argument :lock_version, default: nil

      def call
        raise Maglev::Errors::UnknownSection unless section_definition

        ActiveRecord::Base.transaction do
          if site_scoped?
            update_section_content!(site)
          else
            update_section_content!(page)
          end
        end
      end

      private

      def update_section_content!(source)
        check_section_lock_version!(source)

        source.sections_translations_will_change!
        update_section_content(source)
        source.save!
      end

      def update_section_content(source)
        current_section_content = find_section_content(source)

        section_definition.settings.each do |setting|
          next unless content.key?(setting.id.to_sym)

          update_setting_value(setting, current_section_content)
        end
      end
    end
  end
end
