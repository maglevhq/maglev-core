# frozen_string_literal: true

module Maglev
  class SectionComponent < BaseComponent
    include TagHelper

    extend Forwardable
    def_delegators :parent, :site, :page, :config

    attr_reader :parent, :id, :type, :settings, :attributes, :definition, :templates_root_path, :rendering_mode

    # rubocop:disable Lint/MissingSuper
    def initialize(parent:, attributes:, definition:, templates_root_path:, rendering_mode:)
      @parent = parent # aka a PageComponent
      @id = attributes[:id]
      @type = attributes[:type]
      @definition = definition
      @attributes = attributes
      @templates_root_path = templates_root_path
      @rendering_mode = rendering_mode

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
      "data-maglev-section-id=\"#{id}\" data-maglev-section-type=\"#{type}\"".html_safe
    end
    # rubocop:enable Rails/OutputSafety

    def tag_data
      { maglev_section_id: id, maglev_section_type: type }
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
    rescue StandardError => e
      handle_error(e)
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

    def handle_error(exception)
      raise exception if %i[live section].include?(rendering_mode) || Rails.env.test?

      Rails.logger.error [
        "⚠️  [Maglev] Error when rendering a \"#{type}\" type section ⚠️",
        exception.message,
        *exception.backtrace
      ].join($INPUT_RECORD_SEPARATOR)

      render_error
    end

    def render_error
      <<~HTML
        <div #{dom_data} style="padding: 5rem 0;">
          <div style="max-width: 40rem; margin: 0 auto; background-color: rgb(254 242 242); color: rgb(153 27 27); padding: 1rem; border-radius: 0.375rem;">
            <h3 style="font-weight: 500; color: rgb(153 27 27); font-size: 0.875rem; line-height: 1.25rem;">
              We've encountered an error while rendering the <strong>"#{type}"</strong> section.
            </h3>
            <p style="margin-top: 0.5rem; font-size: 0.775rem; line-height: 1.25rem; color: rgb(185 28 28);">
              Check out your application logs for more details.
            </p>
          </div>
        </div>
      HTML
    end

    def inspect_fields
      %w[id site_id type].map { |field| [field, send(field)] }
    end
  end
end
