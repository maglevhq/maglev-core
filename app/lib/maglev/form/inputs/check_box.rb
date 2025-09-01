# frozen_string_literal: true

module Maglev
  module Form
    module Inputs
      module CheckBox
        def check_box(method, options = {})
          attributes = field_attributes(method)

          @template.render(Maglev::Uikit::Form::CheckboxComponent.new(
                             label: options[:label].presence || attributes[:content],
                             name: attributes[:name],
                             checked: object.public_send(method),
                             placeholder: options[:placeholder]
                           ))
        end
      end
    end
  end
end
