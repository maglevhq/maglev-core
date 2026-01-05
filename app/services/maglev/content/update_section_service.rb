# frozen_string_literal: true

module Maglev
  module Content
    class UpdateSectionService
      include Injectable
      include Maglev::Content::HelpersConcern
      include Maglev::Content::PublishingStateConcern

      dependency :fetch_theme
      dependency :fetch_site

      argument :store
      argument :section_id
      argument :content
      argument :lock_version, default: nil

      def call
        raise Maglev::Errors::UnknownSection unless section_definition

        ActiveRecord::Base.transaction do
          unsafe_call
        end
      end

      private

      def unsafe_call
        if site_scoped?
          add_missing_site_scoped_section # make sure the section is also present in the site scoped store
          update_section_content!(site_scoped_store)
        else
          update_section_content!(store)
        end.tap { touch_page(store) }
      end

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

      def add_missing_site_scoped_section
        # if a section has been declared site_scoped after the section has been added to the store,
        # we need to add it to the site scoped store
        return if find_section(site_scoped_store)

        original_section = find_section(store).dup

        site_scoped_store.sections << original_section
      end
    end
  end
end
