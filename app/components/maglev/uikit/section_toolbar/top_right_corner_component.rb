# frozen_string_literal: true

module Maglev
  module Uikit
    module SectionToolbar
      class TopRightCornerComponent < Maglev::Uikit::BaseComponent
        attr_reader :id, :paths, :options

        def initialize(id:, paths:, options:)
          @id = id
          @paths = paths
          @options = options
        end

        def blocks?
          !!options[:has_blocks]
        end

        def button_classes
          %(relative bg-white z-50 rounded-full shadow-xl h-8 w-8
            flex items-center justify-center
            text-gray-700 pointer-events-auto hover:text-black cursor-pointer
          )
        end
      end
    end
  end
end
