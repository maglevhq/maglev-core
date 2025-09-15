# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class SelectComponent < ViewComponent::Base
        attr_reader :label, :name, :choices, :options, :html_options, :input_data, :input_action

        def initialize(label:, name:, choices:, options: {}, html_options: {})
          @label = label
          @name = name
          @choices = choices
          @options = options
          @html_options = html_options
          @input_data = html_options.delete(:data) || {}
          @input_action = input_data.delete(:action)
        end

        def dom_id
          name.to_s.parameterize.underscore
        end

        def error
          options[:error]
        end

        def input_tag_options
          {
            id: dom_id,
            value: options[:value],
            **options.slice(:multiple, :disabled, :include_blank, :prompt),
            data: input_tag_data
          }
        end

        def input_tag_data
          {
            action: [
              'change->uikit-form-select#change',
              **input_action
            ].join(' '),
            **input_data
          }
        end

        def html_choices
          helpers.options_for_select(choices, options[:value])
        end
      end
    end
  end
end
