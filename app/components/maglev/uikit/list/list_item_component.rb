# frozen_string_literal: true

module Maglev
  module Uikit
    module List
      class ListItemComponent < Maglev::Uikit::BaseComponent
        renders_one :handle
        renders_one :image
        renders_one :big_image
        renders_one :icon
        renders_one :pre_title
        renders_one :sub_title
        renders_one :title
        renders_one :action

        attr_reader :link, :index, :options, :variant, :wrapper_tag_name

        def initialize(id: nil, link: nil, options: {})
          @id = id
          @link = link
          @variant = options.fetch(:variant, :filled).to_sym
          @custom_wrapper_classes = options[:wrapper_classes]
          @wrapper_tag_name = options[:wrapper_tag] || :div
          @index = options[:index]
          @options = options
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

        # rubocop:disable Metrics/MethodLength
        def wrapper_classes
          class_variants(
            base: 'rounded-md flex text-gray-800',
            variants: {
              variant: {
                filled: 'bg-gray-100',
                ghost: 'hover:bg-gray-50 transition-colors duration-200'
              },
              padding: { default: 'p-2', medium: 'p-3' }
            },
            default: { variant: :filled, padding: :default }
          ).render(variant: variant, padding: big_image? ? :medium : :default, class: @custom_wrapper_classes)
        end
        # rubocop:enable Metrics/MethodLength

        def content_classes
          class_variants(
            base: 'flex flex-1 gap-3 overflow-hidden',
            variants: {
              disposition: {
                row: 'flex-row items-center px-2',
                col: 'flex-col'
              }
            },
            default: { disposition: :col }
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

        def sortable_scope
          options[:sortable_scope]
        end

        def sortable_target
          sortable_scope.present? ? "item-#{sortable_scope}" : 'item'
        end

        def sortable_handle
          sortable_scope.present? ? "handle-#{sortable_scope}" : 'handle'
        end
      end
    end
  end
end
