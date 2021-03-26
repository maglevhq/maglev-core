# frozen_string_literal: true

module Maglev
  class SectionComponent < BaseComponent
    attr_reader :parent, :id, :type, :settings, :attributes, :definition

    def initialize(parent:, attributes:, definition:)
      @parent = parent
      @id = attributes[:id]
      @type = attributes[:type]
      @definition = definition
      @attributes = attributes

      @settings = settings_proxy(
        build_settings_map(attributes[:settings])
      )
    end

    def dom_data
      "data-maglev-section-id=\"#{id}\"".html_safe
    end

    def blocks
      @blocks ||= (attributes[:blocks] || []).map do |block_attributes|
        build(
          BlockComponent,
          section: self,
          definition: definition.blocks.find { |settings| settings.type === block_attributes[:type] },
          attributes: block_attributes
        )
      end
    end

    def render
      super(
        template: "./theme/sections/#{type}",
        locals: { section: self }
      )
    end
  end
end
