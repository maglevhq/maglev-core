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

      def site_scoped?
        section_definition.site_scoped?
      end

      def section_definition
        # by default, use the page to find the section definition since every site scoped section is also in the page
        @section_definition ||= theme.sections.find(
          find_section&.fetch('type', nil)
        )
      end

      def block_definition
        @block_definition ||= find_block_definition
      end

      def find_section(source = page)
        source.find_section_by_id(section_id)
      end

      def find_section_definition(source, section_id)
        theme.sections.find(find_section(source, section_id)&.fetch('type', nil))
      end

      def find_section_content(source)
        find_section(source)['settings']
      end

      def find_blocks(source)
        find_section(source)['blocks']
      end

      def find_block(source)
        find_blocks(source).find { |block| block['id'] == block_id }
      end

      def find_block_content(source)
        find_block(source)['settings']
      end

      def find_block_definition(source = page)
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
    end
  end
end
