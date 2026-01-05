# frozen_string_literal: true

module Maglev
  module Content
    class SectionContent
      include ActiveModel::Model
      include Maglev::Content::EnhancedValueConcern

      attr_accessor :id, :type, :settings, :blocks, :definition, :theme_id, :store_handle, :lock_version, :mirror_of

      def persisted?
        true
      end

      def sticky?
        definition.viewport_fixed_position?
      end

      def mirrored?
        mirror_of.present? && mirror_of['enabled'] == true
      end

      delegate :site_scoped?, to: :definition

      def type_name
        definition.human_name
      end

      def blocks?
        blocks.present?
      end

      def block_definitions
        definition.blocks
      end

      def root_blocks
        blocks.select(&:root?)
      end

      # return the definitions of root blocks that can be added
      def root_block_definitions
        definition.root_blocks.select { |block_definition| blocks.can_add?(block_definition.type) }
      end

      # return the definitions of blocks that can be added as children of the given block
      def child_block_definitions_of(block_id)
        accepted_block_types = blocks.find(block_id).accepted_child_types
        definition.blocks.select do |block_definition|
          accepted_block_types.include?(block_definition.type) && blocks.can_add?(block_definition.type)
        end
      end

      def blocks_label
        definition.human_blocks_label(::I18n.t('maglev.editor.section_blocks.breadcrumb'))
      end

      def child_blocks_of(block_id)
        blocks.select { |block| block.parent_id == block_id }
      end

      def build_blocks(raw_section_content)
        self.blocks = Maglev::Content::BlockContent::AssociationProxy.new(
          section_content: self,
          raw_blocks_content: raw_section_content['blocks']
        )
      end

      def self.build_many(theme:, store_handle:, content:)
        content.map do |raw_section_content|
          build(theme: theme, store_handle: store_handle, raw_section_content: raw_section_content)
        end
      end

      def self.build(theme:, store_handle:, raw_section_content:)
        build_without_blocks(theme: theme, store_handle: store_handle,
                             raw_section_content: raw_section_content).tap do |section_content|
          section_content.build_blocks(raw_section_content)
        end
      end

      def self.build_without_blocks(theme:, store_handle:, raw_section_content:)
        new(
          id: raw_section_content['id'],
          definition: theme.sections.find(raw_section_content['type']),
          type: raw_section_content['type'],
          settings: Maglev::Content::SettingContent::AssociationProxy.new(raw_section_content['settings']),
          theme_id: theme.id,
          store_handle: store_handle,
          lock_version: raw_section_content['lock_version'],
          mirror_of: raw_section_content['mirror_of']
        )
      end
    end
  end
end
