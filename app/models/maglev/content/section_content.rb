# frozen_string_literal: true

module Maglev
  module Content
    class SectionContent
      include ActiveModel::Model
      include Maglev::Content::EnhancedValueConcern

      attr_accessor :id, :type, :settings, :blocks, :definition, :theme_id

      def persisted?
        true
      end

      def sticky?
        definition.viewport_fixed_position?
      end

      def blocks?
        blocks.present?
      end

      def type_name
        ::I18n.t("#{i18n_scope}.type", default: definition.name)
      end

      def blocks_label
        ::I18n.t("#{i18n_scope}.blocks.label",
                 default: definition.blocks_label || ::I18n.t('maglev.editor.section_pane.tabs.blocks'))
      end

      def i18n_scope
        "maglev.themes.#{definition.theme.id}.sections.#{type}"
      end

      def build_blocks(raw_section_content)
        self.blocks = Maglev::Content::BlockContent::AssociationProxy.new(
          section_content: self,
          raw_blocks_content: raw_section_content['blocks']
        )
      end

      def self.build_many(theme:, content:)
        content.map do |raw_section_content|
          build(theme: theme, raw_section_content: raw_section_content)
        end
      end

      def self.build(theme:, raw_section_content:)
        new(
          id: raw_section_content['id'],
          definition: theme.sections.find(raw_section_content['type']),
          type: raw_section_content['type'],
          settings: Maglev::Content::SettingContent::AssociationProxy.new(raw_section_content['settings']),
          theme_id: theme.id
        ).tap do |section_content|
          section_content.build_blocks(raw_section_content)
        end
      end
    end
  end
end
