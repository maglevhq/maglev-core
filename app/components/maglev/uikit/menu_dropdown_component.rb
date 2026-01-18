# frozen_string_literal: true

module Maglev
  module Uikit
    class MenuDropdownComponent < Maglev::Uikit::BaseComponent
      renders_one :trigger
      renders_many :items

      attr_reader :icon_name, :placement, :wrapper_classes, :trigger_classes

      def initialize(icon_name: nil, placement: 'bottom-start', wrapper_classes: nil, trigger_classes: nil)
        @icon_name = icon_name
        @placement = placement
        @wrapper_classes = wrapper_classes
        @trigger_classes = trigger_classes
      end

      def item_classes(...)
        class_variants(
          base: %(
            flex items-center px-4 py-4 hover:bg-gray-100 w-full
            transition-colors duration-200 focus:outline-none cursor-pointer flex-1
          )
        ).render(...)
      end

      def form_item_classes(...)
        class_variants(
          base: 'flex items-center focus:outline-none cursor-pointer'
        ).render(...)
      end
    end
  end
end
