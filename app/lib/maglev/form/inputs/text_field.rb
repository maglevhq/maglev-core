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
                             value: object.public_send(method),
                             placeholder: options[:placeholder],
                             error: error_messages(method)
                           ))
        end
      end
    end
  end
end
