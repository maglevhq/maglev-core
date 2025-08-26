# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class ImageFieldComponentPreview < ViewComponent::Preview
        # @!group Variants
        def default
          render Maglev::Uikit::Form::ImageFieldComponent.new(
            label: 'Image',
            name: 'section[background_image]',
            value: nil,
            search_path: '#'
          )
        end

        def with_an_image
          render Maglev::Uikit::Form::ImageFieldComponent.new(
            label: 'Image',
            name: 'section[background_image]',
            value: '/images/img-1.jpg',
            search_path: '#'
          )
        end

        def with_an_image_and_alt_text
          render Maglev::Uikit::Form::ImageFieldComponent.new(
            label: 'Image',
            name: 'section[background_image][url]',
            value: '/images/img-2.jpg',
            alt_text: {
              name: 'section[background_image][alt_text]',
              value: nil,
              placeholder: 'Alt text to help search engines'
            },
            search_path: '#'
          )
        end

        # @!endgroup
      end
    end
  end
end
