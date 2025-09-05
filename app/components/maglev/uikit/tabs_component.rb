# frozen_string_literal: true

module Maglev
  module Uikit
    class TabsComponent < Maglev::Uikit::BaseComponent
      renders_many :tabs, lambda { |label:, active: false, link: nil, &block|
        Tab.new(self, label: label, active: active, link: link, block: block)
      }

      attr_reader :container_classes, :active_tab, :active_tab_index

      def initialize(container_classes: nil, active_tab_index: nil)
        @container_classes = container_classes
        @active_tab_index = active_tab_index
      end

      def label_classes(...)
        class_variants(
          base: %(
            relative py-1 pb-0 px-4 block focus:outline-none border-b-2
            z-10 font-medium hover:text-editor-primary
          ),
          variants: {
            active: 'text-editor-primary border-editor-primary',
            '!active': 'text-gray-500 border-transparent'
          }
        ).render(...)
      end

      def before_render
        @active_tab = tabs.find(&:active?) || tabs[active_tab_index.to_i]
        @active_tab.active = true
      end

      class Tab < Maglev::Uikit::BaseComponent
        attr_reader :label, :block, :link
        attr_writer :active

        def initialize(component, label:, active:, link:, block: nil)
          @component = component
          @label = label
          @active = active
          @link = link
          @block = block
        end

        def active?
          @active
        end

        def block?
          @block.present?
        end

        def link?
          @link.present?
        end

        def link_html_options
          @link[:html_options] || {}
        end        
      end
    end
  end
end
