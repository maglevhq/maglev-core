# frozen_string_literal: true

module Maglev
  module Content
    class BlockContent
      include ActiveModel::Model
      include Maglev::Content::EnhancedValueConcern

      attr_accessor :id, :type, :settings, :definition, :position, :parent_id, :position_in_parent

      def persisted?
        true
      end

      delegate :root?, to: :definition

      def accepted_child_types
        definition.accept || []
      end

      def name
        definition.human_name
      end

      def self.build(raw_block_content:, definition:, position:)
        new(
          id: raw_block_content['id'],
          definition: definition,
          type: raw_block_content['type'],
          settings: Maglev::Content::SettingContent::AssociationProxy.new(raw_block_content['settings']),
          parent_id: raw_block_content['parent_id'],
          position: position
        )
      end

      def self.build_many(raw_blocks_content:, section_content:)
        raw_blocks_content.each_with_index.map do |raw_block_content, index|
          build(
            raw_block_content: raw_block_content,
            definition: section_content.definition.blocks.find(raw_block_content['type']),
            position: index
          )
        end.tap { |blocks| compute_position_in_parent(blocks) }
      end

      def self.compute_position_in_parent(blocks)
        memo = {} # key: parent_id, value: number of blocks
        blocks.each do |block|
          memo[block.parent_id] ||= 0
          block.position_in_parent = memo[block.parent_id]
          memo[block.parent_id] += 1
        end
      end

      class AssociationProxy
        include Enumerable

        attr_reader :array

        def initialize(section_content:, raw_blocks_content:)
          @array = Maglev::Content::BlockContent.build_many(
            section_content: section_content,
            raw_blocks_content: raw_blocks_content
          )
        end

        def find(id)
          array.find { |block| block.id == id }
        end

        def find_all_by_type(type)
          array.select { |block| block.type == type }
        end

        def can_add?(type)
          blocks = find_all_by_type(type)

          return true if blocks.empty?

          definition = blocks.first.definition

          definition.limit == -1 || blocks.size < definition.limit
        end

        def each(&block)
          array.each(&block)
        end

        delegate :empty?, to: :array
      end
    end
  end
end
