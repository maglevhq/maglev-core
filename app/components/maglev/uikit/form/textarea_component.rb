# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class TextareaComponent < ViewComponent::Base
        attr_reader :label, :name, :options, :input_data, :input_action, :html_options

        # options: { value: nil, rows: 2, max_length: nil }
        def initialize(label:, name:, options: {}, html_options: {})
          @label = label
          @name = name
          @options = options
          @input_data = html_options.delete(:data) || {}
          @input_action = input_data.delete(:action)
          @html_options = html_options
        end

        def dom_id
          name.to_s.parameterize.underscore
        end

        def placeholder
          options[:placeholder]
        end

        def value
          options[:value]
        end

        def rows
          options[:rows]
        end

        def max_length
          options[:max_length]
        end

        def num_characters
          value.to_s.length
        end

        def max_length?
          max_length.present?
        end

        def error
          options[:error]
        end
      end
    end
  end
end
