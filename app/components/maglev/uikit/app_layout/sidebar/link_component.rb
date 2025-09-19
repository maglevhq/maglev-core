# frozen_string_literal: true

module Maglev
  module Uikit
    module AppLayout
      module Sidebar
        class LinkComponent < Maglev::Uikit::BaseComponent
          attr_reader :path, :icon, :icon_size, :active, :data

          def initialize(path:, icon:, active: false, options: {})
            @path = path
            @active = active
            @icon = icon
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

          def link_classes(...)
            class_variants(
              base: 'flex justify-center py-5 -ml-4 -mr-4 hover:bg-gray-100 transition-colors duration-200',
              variants: {
                active: 'bg-gray-100',
                '!active': 'bg-white'
              }
            ).render(...)
          end
        end
      end
    end
  end
end
