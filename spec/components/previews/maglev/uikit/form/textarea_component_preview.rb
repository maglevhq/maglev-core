# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class TextareaComponentPreview < ViewComponent::Preview
        # @!group Variants
        def default
          render(Maglev::Uikit::Form::TextareaComponent.new(
                   label: 'Label',
                   name: 'name',
                   options: {
                     placeholder: 'Please write something...'
                   }
                 ))
        end

        def with_value
          render(Maglev::Uikit::Form::TextareaComponent.new(
                   label: 'Label',
                   name: 'name',
                   options: {
                     value: 'Lorem ipsum dolor sit amet'
                   }
                 ))
        end

        def with_max_length
          render(Maglev::Uikit::Form::TextareaComponent.new(
                   label: 'Label',
                   name: 'name',
                   options: {
                     value: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quos.',
                     max_length: 10,
                     rows: 5
                   }
                 ))
        end

        def with_error
          render(Maglev::Uikit::Form::TextareaComponent.new(
                   label: 'Label',
                   name: 'name',
                   options: {
                     value: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quos.',
                     max_length: 10,
                     rows: 5,
                     error: 'Error'
                   }
                 ))
        end

        # @!endgroup
      end
    end
  end
end
