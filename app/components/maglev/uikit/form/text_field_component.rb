# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class TextFieldComponent < ViewComponent::Base
        attr_reader :label, :name, :options, :input_data, :input_action, :html_options

        # options: { value: nil, placeholder: nil, error: nil }
        # html_options: { data: { attribute: 'value' } }
        def initialize(label:, name:, options: {}, html_options: {})
          @label = label
          @name = name
          @options = options
          @html_options = html_options
          @input_data = html_options.delete(:data) || {}
          @input_action = input_data.delete(:action)
        end

        def dom_id
          name.to_s.parameterize.underscore
        end

        def value
          options[:value]
        end

        def hint
          options[:hint]
        end

        def placeholder
          options[:placeholder]
        end

        def error
          options[:error]
        end
      end
    end
  end
end
