# frozen_string_literal: true

module Maglev
  module Uikit
    module AppLayout
      module Sidebar
        class LinkComponent < Maglev::Uikit::BaseComponent
          LINK_BASE_CLASSES = [
            'relative flex w-full min-h-11 items-center justify-center rounded py-3',
            'outline-none transition-colors duration-200',
            'focus-visible:ring-2 focus-visible:ring-editor-primary/50',
            'focus-visible:ring-offset-2 focus-visible:ring-offset-white'
          ].join(' ')

          LINK_ACTIVE_CLASSES = 'bg-gray-100 text-editor-primary hover:bg-gray-100'

          LINK_INACTIVE_CLASSES = 'text-black hover:bg-gray-100'

          attr_reader :path, :icon, :icon_size, :active, :data, :label

          def initialize(path:, icon:, active: false, label: nil, options: {})
            @path = path
            @active = active
            @icon = icon
            @label = label
            @icon_size = options[:icon_size] || '1.5rem'
            @position = options[:position] || :top
            @data = options[:data]
          end

          def active?
            @active
          end

          def top?
            @position == :top
          end

          def link_html_options
            {
              class: link_classes(active: active?),
              data: data,
              title: label.presence,
              aria: link_aria_attributes
            }.compact
          end

          def link_classes(...)
            class_variants(
              base: LINK_BASE_CLASSES,
              variants: {
                active: LINK_ACTIVE_CLASSES,
                '!active': LINK_INACTIVE_CLASSES
              }
            ).render(...)
          end

          private

          def link_aria_attributes
            aria = {}
            aria[:label] = label.presence
            aria[:current] = 'page' if active?
            aria.compact.presence
          end
        end
      end
    end
  end
end
