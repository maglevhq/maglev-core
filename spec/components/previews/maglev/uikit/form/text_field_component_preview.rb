# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class TextFieldComponentPreview < ViewComponent::Preview
        # @!group Variants

        def default
          render(Maglev::Uikit::Form::TextFieldComponent.new(
                   label: 'Label',
                   name: 'user[name]'
                 ))
        end

        def with_placeholder
          render(Maglev::Uikit::Form::TextFieldComponent.new(
                   label: 'Label',
                   name: 'user[name]',
                   options: {placeholder: 'Placeholder' }
                 ))
        end

        def with_value
          render(Maglev::Uikit::Form::TextFieldComponent.new(
                   label: 'Label',
                   name: 'user[name]',
                   options: { value: 'Lorem ipsum dolor sit amet' }
                 ))
        end

        def with_error
          render(Maglev::Uikit::Form::TextFieldComponent.new(
                   label: 'Label',
                   name: 'user[name]',
                   options: { error: 'must be present' }
                 ))
        end

        # @!endgroup
      end
    end
  end
end
