# frozen_string_literal: true

module Maglev
  module Content
    class SectionContent
      include ActiveModel::Model

      attr_accessor :id, :type, :settings, :blocks, :definition

      def persisted?
        true
      end

      def label
        definition.settings.each do |setting_definition|
          value = settings.value_of(setting_definition.id)
          next if value.blank?

          label = setting_definition.content_label(value)
          return label if label.present?
        end
        nil
      end

      def label?
        label.present?
      end

      def type_name
        ::I18n.t("maglev.themes.#{definition.theme.id}.sections.#{type}.type", default: definition.name)
      end

      def self.build_many(theme:, content:)
        content.map { |raw_section_content| build(theme: theme, raw_section_content: raw_section_content) }
      end

      def self.build(theme:, raw_section_content:)
        new(
          id: raw_section_content['id'],
          definition: theme.sections.find(raw_section_content['type']),
          type: raw_section_content['type'],
          settings: Maglev::Content::SettingContent::AssociationProxy.new(raw_section_content['settings']),
          blocks: raw_section_content['blocks']
        )
      end
    end
  end
end
