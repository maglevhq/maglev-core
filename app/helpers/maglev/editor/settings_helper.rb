# frozen_string_literal: true

module Maglev
  module Editor
    module SettingsHelper
      def section_form_settings(section, advanced: false)
        render Maglev::Editor::SettingsGroupComponent.new(
          values: section.settings,
          definitions: advanced ? section.definition.advanced_settings : section.definition.main_settings,
          paths: section_settings_paths,
          scope: {
            input: 'section',
            i18n: "maglev.themes.#{section.theme_id}.sections.#{section.type}"
          }
        )
      end

      def section_block_form_settings(section, section_block, advanced: false)
        render Maglev::Editor::SettingsGroupComponent.new(
          values: section_block.settings,
          definitions: advanced ? section_block.definition.advanced_settings : section_block.definition.main_settings,
          paths: section_settings_paths,
          scope: {
            input: 'section_block',
            i18n: "maglev.themes.#{section.theme_id}.sections.#{section.type}.blocks.types.#{section_block.type}"
          }
        )
      end

      def style_form_settings(style, theme)
        render Maglev::Editor::SettingsGroupComponent.new(
          values: style,
          definitions: theme.style_settings,
          scope: { input: 'style', i18n: 'maglev.editor' }
        )
      end

      def section_settings_paths
        {
          collection_items_path: lambda { |definition, _|
            editor_combobox_collection_items_path(collection_id: definition.options[:collection_id])
          },
          assets_path: ->(_, context) { editor_assets_path(source: context[:source], picker: true) },
          edit_link_path: lambda { |_, context|
            edit_editor_link_path(input_name: context[:input_name], link: context[:value])
          },
          icons_path: ->(_, context) { editor_icons_path(source: context[:source]) }
        }
      end
    end
  end
end
