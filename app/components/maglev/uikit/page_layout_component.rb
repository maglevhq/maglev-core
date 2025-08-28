# frozen_string_literal: true

module Maglev
  module Uikit
    class PageLayoutComponent < Maglev::Uikit::BaseComponent
      renders_one :title
      renders_one :description
      renders_one :notification
      renders_one :footer

      attr_reader :back_path, :expanded

      def initialize(back_path: nil, expanded: false)
        @back_path = back_path
        @expanded = expanded
      end

      def wrapper_classes
        class_variants(
          base: 'slide-pane absolute inset-y-0 h-[100dvh-(--spacing(16))] bg-white border-r border-gray-200 origin-top-left flex flex-col top-16 w-104',
          variants: {
            expanded: 'left-0 z-40',
            '!expanded': 'left-16 z-10'
          }
        ).render(expanded: expanded)
      end
    end
  end
end
