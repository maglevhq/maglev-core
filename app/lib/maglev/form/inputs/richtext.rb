# frozen_string_literal: true

module Maglev
  module Form
    module Inputs
      module Richtext
        def richtext(method, options = {})
          attributes = field_attributes(method)

          @template.render(Maglev::Uikit::Form::RichtextComponent.new(
                             label: options[:label].presence || attributes[:content],
                             name: attributes[:name],
                             options: richtext_component_options(method, options),
                             html_options: richtext_component_html_options(options)
                           ))
        end

        def richtext_component_options(method, options)
          {
            value: options.key?(:value) ? options[:value] : object.public_send(method),
            placeholder: options[:placeholder],
            error: error_messages(method)
          }
        end

        def richtext_component_html_options(options)
          options[:html_options] || {}
        end
      end
    end
  end
end
