# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class IconFieldComponentPreview < ViewComponent::Preview
        # @!group Variants
        def default
          render Maglev::Uikit::Form::IconFieldComponent.new(
            name: 'section[icon]',
            search_path: '#',
            options: {
              label: 'Icon',
              value: ''
            }
          )
        end

        def with_value
          render Maglev::Uikit::Form::IconFieldComponent.new(
            name: 'section[icon]',
            search_path: '#',
            options: {
              label: 'Icon',
              value: 'ri-home-heart-line'
            }
          )
        end

        def with_error
          render Maglev::Uikit::Form::IconFieldComponent.new(
            name: 'section[icon]',
            search_path: '#',
            options: {
              label: 'Icon',
              value: 'ri-home-heart-line',
              error: 'must be present'
            }
          )
        end

        # @!endgroup
      end
    end
  end
end
