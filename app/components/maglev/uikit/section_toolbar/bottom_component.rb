# frozen_string_literal: true

module Maglev
  module Uikit
    module SectionToolbar
      class BottomComponent < Maglev::Uikit::BaseComponent
        attr_reader :paths, :options

        def initialize(paths:, options:)
          @paths = paths
          @options = options
        end

        def insert_button?
          options[:insert_button].nil? || !!options[:insert_button]
        end

        def button_classes
          %(bg-editor-primary pointer-events-auto cursor-pointer
            flex items-center justify-center h-8 w-8 rounded-full
            text-white/75 hover:text-white relative top-4
          )
        end
      end
    end
  end
end
