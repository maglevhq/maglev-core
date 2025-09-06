# frozen_string_literal: true

module Maglev
  module Content
    class UpdateSectionBlockService
      include Injectable
      include Maglev::Content::HelpersConcern

      dependency :fetch_theme
      dependency :fetch_site

      argument :page
      argument :section_id
      argument :block_id
      argument :content

      def call
        raise Maglev::Errors::UnknownSection unless section_definition
        raise Maglev::Errors::UnknownBlock unless block_definition

        ActiveRecord::Base.transaction do
          update_section_block_content!(site) if site_scoped?
          update_section_block_content!(page)
        end
      end

      private

      def update_section_block_content!(source)
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
