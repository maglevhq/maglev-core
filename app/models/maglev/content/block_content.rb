# frozen_string_literal: true

module Maglev
  module Content
    class BlockContent
      include ActiveModel::Model
      include Maglev::Content::EnhancedValueConcern

      attr_accessor :id, :type, :settings, :definition, :position

      def persisted?
        true
      end

      def name
        definition.human_name
      end

      def name_with_position
        "#{name} ##{position + 1}"
      end

      def self.build(raw_block_content:, definition:, position:)
        new(
          id: raw_block_content['id'],
          definition: definition,
          type: raw_block_content['type'],
          settings: Maglev::Content::SettingContent::AssociationProxy.new(raw_block_content['settings']),
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

        def each(&block)
          array.each(&block)
        end

        delegate :empty?, to: :array
      end
    end
  end
end
