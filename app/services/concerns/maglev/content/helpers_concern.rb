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
        find_section(source)&.fetch('blocks', nil)
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

      def check_section_lock_version!(source)
        check_lock_version!(source, find_section(source), 'update_section')
      end

      def check_block_lock_version!(source)
        check_lock_version!(source, find_block(source), 'update_block')
      end

      def check_lock_version!(source, section_or_block, action_name)
        return if lock_version.blank? # without a lock version, we disable the lock version check

        current_lock_version = section_or_block['lock_version'].to_i

        # always increment the lock version
        section_or_block['lock_version'] = lock_version.to_i + 1

        # if the lock version is the same, we don't need to raise an error
        return if current_lock_version == lock_version.to_i

        raise ActiveRecord::StaleObjectError.new(source, action_name)
      end
    end
  end
end
