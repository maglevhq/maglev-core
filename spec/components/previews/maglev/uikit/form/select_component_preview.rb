# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class SelectComponentPreview < ViewComponent::Preview
        # @!group Variants

        def default
          render(Maglev::Uikit::Form::SelectComponent.new(
                   label: 'Label',
                   name: 'user[choice]',
                   choices: ['Option 1', 'Option 2', 'Option 3'],
                   options: { include_blank: true }
                 ))
        end

        def with_placeholder
          render(Maglev::Uikit::Form::SelectComponent.new(
                   label: 'Label',
                   name: 'user[choice]',
                   choices: [['Option 1', 'option_1'], ['Option 2', 'option_2'], ['Option 3', 'option_3']],
                   options: { prompt: 'Select an option' }
                 ))
        end

        def with_value
          render(Maglev::Uikit::Form::SelectComponent.new(
                   label: 'Label',
                   name: 'user[choice]',
                   choices: [['Option 1', 'option_1'], ['Option 2', 'option_2'], ['Option 3', 'option_3']],
                   options: { value: 'option_2' }
                 ))
        end

        def with_error
          render(Maglev::Uikit::Form::SelectComponent.new(
                   label: 'Label',
                   name: 'user[choice]',
                   choices: [['Option 1', 'option_1'], ['Option 2', 'option_2'], ['Option 3', 'option_3']],
                   options: {
                     value: 'option_2',
                     error: 'must be compliant'
                   }
                 ))
        end

        # @!endgroup
      end
    end
  end
end
