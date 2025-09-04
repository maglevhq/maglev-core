# frozen_string_literal: true

module Maglev
  module Form
    module Inputs
      module TextField
        def text_field(method, options = {})
          attributes = field_attributes(method)

          @template.render(Maglev::Uikit::Form::TextFieldComponent.new(
                             label: options[:label].presence || attributes[:content],
                             name: attributes[:name],
                             options: text_field_component_options(method, options),
                             html_options: text_field_component_html_options(options)                       
                           ))
        end

        def text_field_component_options(method,options)
          {
            value: options.has_key?(:value) ? options[:value] : object.public_send(method),
            placeholder: options[:placeholder],
            error: error_messages(method)
          }
        end

        def text_field_component_html_options(options)
          options[:html_options] || {}
        end
      end
    end
  end
end
