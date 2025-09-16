# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class ComboboxComponent < ViewComponent::Base
        attr_reader :label, :name, :search_path, :options, :html_options

        # options: {
        #   value: nil, placeholder: nil, error: nil, selected_label: nil,
        #   clearable: false, spread_fields: false
        # }
        # html_options: { data: { attribute: 'value' } }
        def initialize(label:, name:, search_path:, options: {}, html_options: {})
          @label = label
          @name = name
          @search_path = search_path
          @options = options
          @html_options = html_options
        end

        def dom_id
          name.to_s.parameterize.underscore
        end

        def selected_label
          options[:selected_label]
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

        def label_name
          options[:label_name]
        end

        def error
          options[:error]
        end

        def clearable?
          options[:clearable]
        end

        def spread_fields?
          options[:spread_fields]
        end

        def turbo_frame_name
          "#{dom_id}_combobox"
        end
      end
    end
  end
end
