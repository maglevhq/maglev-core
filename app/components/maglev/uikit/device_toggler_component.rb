# frozen_string_literal: true

module Maglev
  module Uikit
    class DeviceTogglerComponent < Maglev::Uikit::BaseComponent
      def toggler_classes(...)
        class_variants(
          base: base_classes,
          variants: {
            active: active_classes
          }
        ).render(...)
      end

      def base_classes
        [
          'cursor-pointer hover:bg-gray-100 h-10 w-10 flex items-center justify-center rounded',
          'outline-none transition-colors duration-200',
          'focus-visible:ring-2 focus-visible:ring-editor-primary/50',
          'focus-visible:ring-offset-2 focus-visible:ring-offset-white'
        ].join(' ').freeze
      end

      def active_classes
        'bg-gray-100'
      end

      def devices
        [
          { icon: 'computer', device: 'desktop' },
          { icon: 'tablet', device: 'tablet' },
          { icon: 'smartphone', device: 'mobile' }
        ]
      end
    end
  end
end
