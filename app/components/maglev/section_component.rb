# frozen_string_literal: true

module Maglev
  class SectionComponent < BaseComponent
    include TagHelper

    extend Forwardable
    def_delegators :parent, :site, :config

    attr_reader :parent, :id, :type, :settings, :attributes, :definition, :templates_root_path

    # rubocop:disable Lint/MissingSuper
    def initialize(parent:, attributes:, definition:, templates_root_path:)
      @parent = parent # aka a PageComponent
      @id = attributes[:id]
      @type = attributes[:type]
      @definition = definition
      @attributes = attributes
      @templates_root_path = templates_root_path

      @settings = settings_proxy(
        build_settings_map(attributes[:settings])
      )
    end
    # rubocop:enable Lint/MissingSuper

    def dom_id
      "section-#{id}"
    end
    
    # rubocop:disable Rails/OutputSafety
    def dom_data
      "data-maglev-section-id=\"#{id}\"".html_safe
    end
    # rubocop:enable Rails/OutputSafety

    def tag_data
      { maglev_section_id: id }
    end

    def blocks
      return @blocks if @blocks

      @blocks = if definition.blocks_presentation == 'tree'
                  build_block_tree
                else
                  build_block_list
                end
    end

    def render
      super(
        template: "#{templates_root_path}/sections/#{definition.category}/#{type}",
        locals: { section: self, maglev_section: self }
      )
    end

    private

    def build_block_list
      build_blocks(attributes[:blocks])
    end

    def build_block_tree(parent_id = nil)
      blocks = attributes[:blocks].select do |block_attributes|
        block_attributes[:parent_id] == parent_id
      end

      build_blocks(blocks) do |block|
        block.children = build_block_tree(block.id)
      end
    end

    def build_blocks(blocks)
      (blocks || []).map do |block_attributes|
        block_definition = definition.blocks.find { |settings| settings.type == block_attributes[:type] }
        next unless block_definition

        block = build_block(block_definition, block_attributes)

        yield block if block_given?

        block
      end.compact
    end

    def build_block(block_definition, block_attributes)
      build(
        BlockComponent,
        section: self,
        definition: block_definition,
        attributes: block_attributes
      )
    end
  end
end
