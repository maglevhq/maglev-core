# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class IconFieldComponent < Maglev::Uikit::BaseComponent
        attr_reader :name, :options, :search_path

        def initialize(name:, search_path:, options:)
          @name = name
          @options = options
          @search_path = search_path
        end

        def dom_id
          name.to_s.parameterize.underscore
        end

        def label
          options[:label]
        end

        def value
          options[:value]
        end

        def error
          options[:error]
        end

        delegate :blank?, to: :value
      end
    end
  end
end
