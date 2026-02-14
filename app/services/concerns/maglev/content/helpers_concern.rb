# frozen_string_literal: true

module Maglev
  module Content
    module HelpersConcern
      private

      def theme
        @theme ||= fetch_theme.call
      end

      def site
        @site ||= fetch_site.call
      end

      def site_scoped_store
        @site_scoped_store ||= scoped_stores.site_scoped.tap do |store|
          # safely initialize the sections array in the current Maglev locale (Maglev::I18n.current_locale)
          store.sections ||= []
        end
      end

      def fetch_mirrored_store(mirror_of)
        scoped_stores.find_by(handle: mirror_of[:layout_store_id], page: mirror_of[:page_id])
      end

      def scoped_stores
        ::Maglev::SectionsContentStore
      end

      def site_scoped?
        section_definition.site_scoped?
      end

      def section_definition
        # by default, use the store to find the section definition since every site scoped section is also in the store
        @section_definition ||= theme.sections.find(
          find_section&.fetch('type', nil)
        )
      end

      def block_definition
        @block_definition ||= site_scoped? ? find_block_definition(site_scoped_store) : find_block_definition(store)
      end

      def find_section(source = store)
        source.find_section_by_id(section_id)
      end

      def find_section_definition(source, section_id)
        theme.sections.find(find_section(source, section_id)&.fetch('type', nil))
      end

      def find_section_content(source)
        find_section(source)['settings']
      end

      def find_blocks(source)
        find_section(source)&.fetch('blocks', nil)
      end

      def find_block(source)
        find_blocks(source).find { |block| block['id'] == block_id }
      end

      def find_block_content(source)
        find_block(source)['settings']
      end

      def find_block_definition(source = store)
        section_definition.blocks.find(find_block(source)&.fetch('type', nil))
      end

      def update_setting_value(setting, current_content)
        setting_content = current_content.find { |s| s['id'] == setting.id }
        value = content[setting.id.to_sym]

        if setting_content.nil?
          current_content.push({ id: setting.id, value: value })
        else
          setting_content['value'] = value
        end
      end

      def reset_memoization
        @theme = nil
        @site = nil
        @section_definition = nil
        @block_definition = nil
      end
    end
  end
end
