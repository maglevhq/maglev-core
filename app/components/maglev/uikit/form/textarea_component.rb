# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class TextareaComponent < ViewComponent::Base
        attr_reader :label, :name, :options, :html_options

        # options: { value: nil, rows: 2, max_length: nil }
        def initialize(label:, name:, options: {}, html_options: {})
          @label = label
          @name = name
          @options = options
          @html_options = html_options          
        end

        def dom_id
          name.to_s.parameterize.underscore
        end

        def input_html_attributes
          helpers.tag.attributes(
            id: dom_id,
            name: name,
            autocomplete: 'off',
            placeholder: placeholder,
            rows: rows,
            data: {
              'max-length-target': 'input',
              **html_options.delete(:data) || {}
            },
            **html_options
          )
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
