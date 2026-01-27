# frozen_string_literal: true

module Maglev
  module Uikit
    class MenuDropdownComponent < Maglev::Uikit::BaseComponent
      module RenderPolymorphicItems
        extend ActiveSupport::Concern

        included do
          renders_many :items, types: {
            button: lambda { |options = nil|
              Maglev::Uikit::MenuDropdownComponent::ButtonItemComponent.new(options, parent: self)
            },
            link_to: lambda { |options = nil, html_options = nil|
              Maglev::Uikit::MenuDropdownComponent::LinkToItemComponent.new(options, html_options, parent: self)
            },
            button_to: lambda { |options = nil, html_options = nil|
              Maglev::Uikit::MenuDropdownComponent::ButtonToItemComponent.new(options, html_options, parent: self)
            },
            nested_menu: lambda { |placement:|
              Maglev::Uikit::MenuDropdownComponent::NestedMenuComponent.new(placement: placement, parent: self)
            },
            wrapper: lambda { |options = nil|
              Maglev::Uikit::MenuDropdownComponent::WrapperItemComponent.new(options, parent: self)
            },
            divider: -> { Maglev::Uikit::MenuDropdownComponent::DividerItemComponent.new(parent: self) }
          }
        end
      end

      renders_one :trigger
      include RenderPolymorphicItems

      attr_reader :icon_name, :placement, :wrapper_classes, :trigger_classes

      def initialize(icon_name: nil, placement: 'bottom-start', wrapper_classes: nil, trigger_classes: nil)
        @icon_name = icon_name
        @placement = placement
        @wrapper_classes = wrapper_classes
        @trigger_classes = trigger_classes
      end

      def list_item_classes
        'text-gray-800 grid grid-cols-[auto_1fr_auto] min-w-[12rem] my-1'
      end

      # rubocop:disable Metrics/MethodLength
      def item_classes(...)
        class_variants(
          base: %(
            col-span-3 grid grid-cols-subgrid
            flex flex-1 items-center px-2 py-3 w-full mx-1 rounded-sm text-left
            transition-colors duration-200 focus:outline-none cursor-pointer
          ),
          variants: {
            danger: 'text-red-600 hover:bg-red-100',
            '!danger': 'hover:bg-gray-100'
          },
          defaults: { danger: false }
        ).render(...)
      end
      # rubocop:enable Metrics/MethodLength

      def form_item_classes(...)
        class_variants(
          base: %w[
            col-span-3 grid grid-cols-subgrid
            flex items-center focus:outline-none cursor-pointer
          ]
        ).render(...)
      end

      class ItemComponent < ViewComponent::Base
        renders_one :icon
        renders_one :label
        renders_one :sub_label
        renders_one :right_icon

        def self.inner_content
          <<-ERB
            <%= render Maglev::Uikit::IconComponent.new(name: icon.to_s, size: '1.15rem', class_names: 'mr-2 shrink-0') if icon? %>
            <span class="<%= 'col-start-2' unless icon? %> whitespace-nowrap whitespace-nowrap truncate overflow-hidden">
              <%= label %>
            </span>
            <%= render Maglev::Uikit::IconComponent.new(name: 'arrow_right', size: '1.15rem', class_names: 'ml-2 shrink-0') if right_arrow? %>
            <span class="col-start-2 whitespace-nowrap whitespace-nowrap truncate overflow-hidden text-xs text-gray-500">
              <%= sub_label %>
            </span>
          ERB
        end

        def right_arrow?
          false
        end
      end

      class LinkToItemComponent < ItemComponent
        attr_reader :options, :html_options, :parent_component, :variant

        def initialize(options = nil, html_options = nil, parent: nil)
          @parent_component = parent
          @options = options
          @html_options = html_options || {}
          @variant = @html_options[:variant]

          apply_parent_classes
        end

        erb_template <<-ERB
          <%= link_to options, html_options do %>
            #{inner_content}
          <% end %>
        ERB

        private

        def apply_parent_classes
          html_options[:class] = parent_component.item_classes(danger: variant == 'danger', class: html_options[:class])
        end
      end

      class ButtonItemComponent < ItemComponent
        attr_reader :options, :parent_component

        def initialize(options = nil, parent: nil)
          @parent_component = parent
          @options = (options || {}).merge(type: 'button')

          apply_parent_classes
        end

        erb_template <<-ERB
          <%= button_tag options do %>
            #{inner_content}
          <% end %>
        ERB

        private

        def apply_parent_classes
          options[:class] = parent_component.item_classes(class: options[:class])
        end
      end

      class ButtonToItemComponent < LinkToItemComponent
        erb_template <<-ERB
          <%= button_to options, html_options do %>
            #{inner_content}
          <% end %>
        ERB

        private

        def apply_parent_classes
          super
          html_options[:form_class] = parent_component.form_item_classes(class: html_options[:form_class])
        end
      end

      class NestedMenuComponent < ItemComponent
        include RenderPolymorphicItems

        attr_reader :placement, :parent_component

        delegate :list_item_classes, :item_classes, :form_item_classes, to: :parent_component

        alias wrapper_classes form_item_classes

        def initialize(placement:, parent:)
          @placement = placement
          @parent_component = parent
        end

        erb_template <<-ERB
          <%= render Maglev::Uikit::DropdownComponent.new(placement: placement, wrapper_classes: wrapper_classes) do |dropdown| %>
            <% dropdown.with_trigger do %>
              <%= button_tag class: item_classes, data: { action: 'click->uikit-dropdown#toggle', 'uikit-dropdown-target': 'button' } do %>
                #{inner_content}#{'                '}
              <% end %>
            <% end %>

            <div class="<%= list_item_classes %>">
              <% items.each do |item| %>
                <%= item %>
              <% end %>
            </div>
          <% end %>
        ERB

        def right_arrow?
          true
        end
      end

      class WrapperItemComponent < Maglev::Uikit::BaseComponent
        include RenderPolymorphicItems

        attr_reader :options, :parent_component

        delegate :item_classes, :form_item_classes, to: :parent_component

        def initialize(options, parent: nil)
          @parent_component = parent
          @options = options || {}

          apply_parent_classes
        end

        erb_template <<-ERB
          <%= tag.div(**options) do %>
            <% items.each do |item| %>
              <%= item %>
            <% end %>
          <% end %>
        ERB

        private

        def apply_parent_classes
          options[:class] = parent_component.form_item_classes(class: options[:class])
        end
      end

      class DividerItemComponent < ItemComponent
        attr_reader :parent_component

        def initialize(parent:)
          @parent_component = parent
        end

        def item_classes(...)
          parent_component.form_item_classes(class: 'border-t border-gray-200 my-1 px-0!')
        end

        erb_template <<-ERB
          <%= tag.hr class: item_classes %>
        ERB
      end
    end
  end
end
