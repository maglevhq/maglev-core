# frozen_string_literal: true

module Maglev
  class BlockComponent < BaseComponent
    attr_reader :section, :id, :name, :type, :settings, :attributes, :definition
    attr_accessor :children

    # rubocop:disable Lint/MissingSuper
    def initialize(section:, attributes:, definition:)
      @section = section
      @id = attributes[:id]
      @name = attributes[:name]
      @type = attributes[:type]
      @children = children
      @definition = definition

      @settings = settings_proxy(
        build_settings_map(attributes[:settings])
      )
    end
    # rubocop:enable Lint/MissingSuper

    def children?
      children.present?
    end

    def dom_data
      "data-maglev-block-id=\"#{id}\"".html_safe
    end
  end
end
