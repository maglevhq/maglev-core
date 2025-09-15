# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class ImageFieldComponentPreview < ViewComponent::Preview
        # @!group Variants

        def default
          render Maglev::Uikit::Form::ImageFieldComponent.new(
            name: 'section[background_image]',
            search_path: '#',
            options: {
              label: 'Image',
              value: nil
            }
          )
        end

        def with_an_image
          render Maglev::Uikit::Form::ImageFieldComponent.new(
            name: 'section[background_image]',
            search_path: '#',
            options: {
              label: 'Image',
              value: '/images/img-1.jpg'
            }
          )
        end

        # rubocop:disable Metrics/MethodLength
        def with_an_image_and_alt_text
          render Maglev::Uikit::Form::ImageFieldComponent.new(
            name: 'section[background_image][url]',
            search_path: '#',
            options: {
              label: 'Image',
              value: '/images/img-2.jpg'
            },
            alt_text: {
              name: 'section[background_image][alt_text]',
              value: nil,
              placeholder: 'Alt text to help search engines'
            }
          )
        end

        def with_extra_fields
          render Maglev::Uikit::Form::ImageFieldComponent.new(
            name: 'section[background_image]',
            search_path: '#',
            options: {
              label: 'Image',
              value: '/images/img-2.jpg',
              extra_fields: true
            },
            alt_text: {
              name: 'section[background_image][alt_text]',
              value: nil,
              placeholder: 'Alt text to help search engines'
            }
          )
        end
        # rubocop:enable Metrics/MethodLength

        # @!endgroup
      end
    end
  end
end
