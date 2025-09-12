# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class ColorFieldComponent < ViewComponent::Base
        attr_reader :name, :options, :html_options

        def initialize(name:, options: {}, html_options: {})
          @name = name
          @options = options
          @html_options = html_options
        end

        def dom_id
          name.to_s.parameterize.underscore
        end

        def label
          options[:label] || name.humanize
        end

        def value
          options[:value]
        end

        def value?
          value.present?
        end

        def presets
          options[:presets]
        end

        def presets?
          presets&.any?
        end

        def hint
          options[:hint]
        end

        def error
          options[:error]
        end

        def input_data
          @input_data ||= html_options.delete(:data) || {}
        end

        def input_action
          @input_action ||= input_data.delete(:action)
        end
      end
    end
  end
end
