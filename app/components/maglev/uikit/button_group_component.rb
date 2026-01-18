module Maglev
  module Uikit
    class ButtonGroupComponent <  Maglev::Uikit::BaseComponent
      renders_many :buttons

      attr_reader :color, :size

      def initialize(color: nil, size: nil)
        @color = color || :primary
        @size = size || :medium
      end

      def button_classes
        class_variants(
          base: %(
            inline-flex items-center justify-center cursor-pointer
            group-[.is-success]/form:bg-green-500/95 group-[.is-success]/form:hover:bg-green-500/100
            group-[.is-success]/form:disabled:bg-green-500/75
            group-[.is-error]/form:bg-red-500/95 group-[.is-error]/form:hover:bg-red-500/100
            group-[.is-error]/form:disabled:bg-red-500/75
          ),
          variants: {
            size: {
              medium: 'inline-flex items-center justify-center px-4 h-10'
            },
            color: {
              primary: 'text-white bg-editor-primary hover:bg-editor-primary/90 disabled:bg-editor-primary/75',
              secondary: 'text-gray-800 hover:bg-gray-100'
            }
          }
        ).render(color: color, size: size)
      end

      def wrapper_classes(**args)
        class_variants(
          base: %(
            inline-flex items-center transition-colors duration-200 h-full
            [.is-success]:bg-green-500/95 [.is-success]:hover:bg-green-500/100
            [.is-success]:disabled:bg-green-500/75
            [.is-error]:bg-red-500/95 [.is-error]:hover:bg-red-500/100
            [.is-error]:disabled:bg-red-500/75
          ),
          variants: {
            color: {
              primary: 'text-white bg-editor-primary hover:bg-editor-primary/90 has-[:disabled]:bg-editor-primary/75',
              secondary: 'text-gray-800 hover:bg-gray-100'
            }
          }
        ).render(color: color, **args)
      end

      def wrapped_button_classes(**args)
        class_variants(
          base: 'cursor-pointer',
          variants: {
          size: {
            medium: 'inline-flex items-center justify-center px-4 h-10'
          }          
        },
        ).render(size: size, **args)
      end
    end
  end
end