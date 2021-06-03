# frozen_string_literal: true

module Maglev
  class SectionComponent < BaseComponent
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

    def dom_data
      "data-maglev-section-id=\"#{id}\"".html_safe
    end

    def blocks
      @blocks ||= (attributes[:blocks] || []).map do |block_attributes|
        block_definition = definition.blocks.find { |settings| settings.type == block_attributes[:type] }
        next unless block_definition

        build(
          BlockComponent,
          section: self,
          definition: block_definition,
          attributes: block_attributes
        )
      end.compact
    end

    def render
      super(
        template: "#{templates_root_path}/sections/#{type}",
        locals: { section: self }
      )
    end
  end
end
