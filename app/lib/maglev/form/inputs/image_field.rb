# frozen_string_literal: true

module Maglev
  module Form
    module Inputs
      module ImageField
        def image_field(method, options = {})
          attributes = field_attributes(method)

          @template.render(Maglev::Uikit::Form::ImageFieldComponent.new(
                             label: options[:label].presence || attributes[:content],
                             name: attributes[:name],
                             value: object.public_send(method),
                             alt_text: options[:alt_text],
                             search_path: image_search_path(attributes, options)
                           ))
        end

        protected

        def image_search_path(attributes, options)
          if options[:search_path].is_a?(Proc)
            source = attributes[:name].to_s.parameterize.underscore # same as the dom id of the field
            options[:search_path].call({ picker: true, source: source })
          else
            options[:search_path]
          end
        end
      end
    end
  end
end
