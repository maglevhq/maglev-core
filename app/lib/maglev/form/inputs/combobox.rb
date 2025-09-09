# frozen_string_literal: true

module Maglev
  module Form
    module Inputs
      module Combobox
        def combobox(method, options = {})
          attributes = field_attributes(method)

          @template.render(Maglev::Uikit::Form::ComboboxComponent.new(
                             label: options[:label].presence || attributes[:content],
                             name: attributes[:name],
                             search_path: options[:search_path],
                             options: combobox_component_options(method, options),
                             html_options: options[:html_options]
                           ))
        end

        protected

        def combobox_component_options(method, options)
          {
            value: options.key?(:value) ? options[:value] : object.public_send(method),
            selected_label: options[:selected_label],
            placeholder: options[:placeholder],
            error: error_messages(method)
          }
        end        
      end
    end
  end
end
