# frozen_string_literal: true

module Maglev
  class BlockComponent < BaseComponent
    include TagHelper

    extend Forwardable
    def_delegators :section, :site, :page, :config

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

    def dom_id
      "block-#{id}"
    end

    # rubocop:disable Rails/OutputSafety
    def dom_data
      "data-maglev-block-id=\"#{id}\"".html_safe
    end
    # rubocop:enable Rails/OutputSafety

    def tag_data
      { maglev_block_id: id }
    end

    private

    def section_id
      section.id
    end

    def inspect_fields
      %w[id site_id section_id name type].map { |field| [field, send(field)] }
    end
  end
end
