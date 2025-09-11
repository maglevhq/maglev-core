# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class RichtextComponentPreview < ViewComponent::Preview
        # @!group Variants
        def default
          render(Maglev::Uikit::Form::RichtextComponent.new(
                   label: 'Label',
                   name: 'name',
                   options: {
                     placeholder: 'Please write something...'
                   }
                 ))
        end

        def with_value
          render(Maglev::Uikit::Form::RichtextComponent.new(
                   label: 'Label',
                   name: 'name',
                   options: {
                     value: 'Lorem ipsum dolor sit amet'
                   }
                 ))
        end

        def with_error
          render(Maglev::Uikit::Form::RichtextComponent.new(
                   label: 'Label',
                   name: 'name',
                   options: {
                     value: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quos.',
                     error: 'Error'
                   }
                 ))
        end

        # @!endgroup
      end
    end
  end
end
