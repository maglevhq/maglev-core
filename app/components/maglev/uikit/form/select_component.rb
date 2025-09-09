# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class SelectComponent < ViewComponent::Base
        attr_reader :label, :name, :choices, :options, :html_options

        def initialize(label:, name:, choices:, options: {}, html_options: {})
          @label = label
          @name = name
          @choices = choices
          @options = options
          @html_options = html_options
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
            **options.slice(:multiple, :disabled, :include_blank, :prompt, :data)
          }
        end

        def html_choices
          helpers.options_for_select(choices, options[:value])
        end
      end
    end
  end
end
