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
                             value: object.public_send(method),
                             rows: options[:rows],
                             max_length: options[:max_length]
                           ))
        end
      end
    end
  end
end
