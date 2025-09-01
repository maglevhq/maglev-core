# frozen_string_literal: true

module Maglev
  module Uikit
    module List
      class ListItemComponent < Maglev::Uikit::BaseComponent
        renders_one :handle
        renders_one :image
        renders_one :big_image
        renders_one :pre_title
        renders_one :title
        renders_one :action

        attr_reader :link, :index

        def initialize(id: nil, link: nil, options: {})
          @id = id
          @link = link
          @custom_wrapper_classes = options[:wrapper_classes]
          @index = options[:index]
        end

        def id
          @id || SecureRandom.uuid
        end

        def link?
          link.present?
        end

        def link_url
          link[:url]
        end

        def link_data
          link[:data] || {}
        end

        def wrapper_classes
          class_variants(
            base: 'bg-gray-100 rounded-md px-2 flex text-gray-800'
          ).render(class: @custom_wrapper_classes)
        end

        def content_classes
          class_variants(
            base: 'flex flex-1 py-3 gap-3 overflow-hidden px-2',
            variants: {
              disposition: {
                row: 'flex-row items-center',
                col: 'flex-col'
              }
            },
            default: {
              disposition: :col
            }
          ).render(disposition: big_image? ? :col : :row)
        end

        def image_classes(...)
          class_variants(
            base: 'object-cover w-full h-full'
          ).render(...)
        end

        def big_image_classes(...)
          class_variants(
            base: 'w-full'
          ).render(...)
        end
      end
    end
  end
end
