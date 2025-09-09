# frozen_string_literal: true

module Maglev
  module Form
    module Inputs
      module Select
        def select(method, select_options, options = {})
          attributes = field_attributes(method)

          @template.render(Maglev::Uikit::Form::SelectComponent.new(
                             label: options[:label].presence || attributes[:content],
                             name: attributes[:name],
                             choices: select_options,
                             options: select_component_options(method, options),
                             html_options: select_component_html_options(options)
                           ))
        end

        def select_component_options(method, options)
          {
            value: options.key?(:value) ? options[:value] : object.public_send(method),
            prompt: options[:prompt],
            include_blank: options[:include_blank],
            error: error_messages(method)
          }
        end

        def select_component_html_options(options)
          options[:html_options] || {}
        end
      end
    end
  end
end
