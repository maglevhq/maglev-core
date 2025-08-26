# frozen_string_literal: true

module Maglev
  module Uikit
    module List
      class InsertButtonComponent < Maglev::Uikit::BaseComponent
        attr_reader :link, :index

        def initialize(link:, index: nil)
          @link = link
          @index = index
        end

        def link_url
          link[:url]
        end

        def link_data
          link[:data] || {}
        end

        def color_class
          [
            'bg-gray-500/20',
            'bg-red-500/20',
            'bg-blue-500/20',
            'bg-green-500/20',
            'bg-yellow-500/20'
          ][index]
        end

        def wrapper_classes(...)
          class_variants(
            base: 'relative w-full h-7 group/button z-10 -mb-5 -mt-5 group-[.is-dragging]:hidden'
          ).render(...)
        end
      end
    end
  end
end
