# frozen_string_literal: true

module Maglev
  module Content
    class UpdateSectionBlockService
      include Injectable
      include Maglev::Content::HelpersConcern
      include Maglev::Content::PublishingStateConcern

      dependency :fetch_theme
      dependency :fetch_site

      argument :store
      argument :section_id
      argument :block_id
      argument :content
      argument :lock_version, default: nil

      def call
        raise Maglev::Errors::UnknownSection unless section_definition
        raise Maglev::Errors::UnknownBlock unless block_definition

        ActiveRecord::Base.transaction do
          unsafe_call
        end
      end

      private

      def unsafe_call
        if site_scoped?
          update_section_block_content!(site_scoped_store)
        else
          update_section_block_content!(store)
        end.tap { touch_page(store) }
      end

      def update_section_block_content!(source)
        check_block_lock_version!(source)

        source.sections_translations_will_change!
        update_section_block_content(source)
        source.save!
      end

      def update_section_block_content(source)
        current_section_block_content = find_block_content(source)

        block_definition.settings.each do |setting|
          next unless content.key?(setting.id.to_sym)

          update_setting_value(setting, current_section_block_content)
        end
      end
    end
  end
end
