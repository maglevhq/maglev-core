# frozen_string_literal: true

module Maglev
  module Form
    module Inputs
      module Textarea
        def textarea(method, options = {})
          attributes = field_attributes(method)

          @template.render(Maglev::Uikit::Form::TextareaComponent.new(
                             label: options[:label].presence || attributes[:content],
                             name: attributes[:name],
                             options: textarea_component_options(method, options),
                             html_options: options[:html_options] || {}
                           ))
        end

        def textarea_component_options(method, options)
          {
            value: object.public_send(method),
            rows: options[:rows],
            max_length: options[:max_length],
            placeholder: options[:placeholder],
            error: error_messages(method)
          }
        end
      end
    end
  end
end
