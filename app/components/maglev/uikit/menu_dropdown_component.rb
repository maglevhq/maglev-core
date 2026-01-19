# frozen_string_literal: true

module Maglev
  module Uikit
    class MenuDropdownComponent < Maglev::Uikit::BaseComponent
      renders_one :trigger
      renders_many :items, types: {
        link_to: lambda { |options = nil, html_options = nil| 
          Maglev::Uikit::MenuDropdownComponent::LinkToItemComponent.new(options, html_options, parent: self)
        },
        button_to: lambda { |options = nil, html_options = nil|
          Maglev::Uikit::MenuDropdownComponent::ButtonToItemComponent.new(options, html_options, parent: self)
        },
        nested_menu: lambda { |placement:|
          Maglev::Uikit::MenuDropdownComponent::NestedMenuComponent.new(placement: placement)
        }
      }

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
            col-span-2 grid grid-cols-subgrid
            flex items-center px-2 py-2 hover:bg-gray-100 w-full rounded-sm
            transition-colors duration-200 focus:outline-none cursor-pointer flex-1
            text-left
          )
        ).render(...)
      end

      def form_item_classes(...)
        class_variants(
          base: %w(
            col-span-2 grid grid-cols-subgrid
            flex items-center focus:outline-none cursor-pointer
          )
        ).render(...)
      end

      class ItemComponent < ViewComponent::Base
        renders_one :icon
        renders_one :label
        renders_one :sub_label

        def self.inner_content 
          <<-ERB
            <%= render Maglev::Uikit::IconComponent.new(name: icon.to_s, size: '1.15rem', class_names: 'mr-2') if icon? %>
            <span class="whitespace-nowrap <%= 'col-start-2' unless icon? %>">
              <%= label %>
            </span>
            <span class="col-start-2 whitespace-nowrap text-xs text-gray-500">
              <%= sub_label %>
            </span>
          ERB
        end
      end

      class LinkToItemComponent < ItemComponent
        # renders_one :icon
        # renders_one :label
        # renders_one :sub_label

        attr_reader :options, :html_options, :parent_component

        def initialize(options = nil, html_options = nil, parent: nil)          
          @parent_component = parent
          @options = options
          @html_options = html_options || {}
          
          apply_parent_classes
        end

        # erb_template <<-ERB
        #   <%= link_to options, html_options do %>
        #     <%= render Maglev::Uikit::IconComponent.new(name: icon.to_s, size: '1.15rem', class_names: 'mr-2') if icon? %>
        #     <span class="whitespace-nowrap <%= 'col-start-2' unless icon? %>">
        #       <%= label %>
        #     </span>
        #     <span class="col-start-2 whitespace-nowrap text-xs text-gray-500">
        #       <%= sub_label %>
        #     </span>
        #   <% end %>
        # ERB
        erb_template <<-ERB
          <%= link_to options, html_options do %>
            #{inner_content}
          <% end %>
        ERB

        private

        def apply_parent_classes
          html_options[:class] = parent_component.item_classes(class: html_options[:class])
        end
      end

      class ButtonToItemComponent < LinkToItemComponent
        erb_template <<-ERB
          <%= button_to options, html_options do %>
            <%= render Maglev::Uikit::IconComponent.new(name: icon.to_s, size: '1.15rem', class_names: 'mr-2') if icon? %>
            <span class="whitespace-nowrap <%= 'col-start-2' unless icon? %>">
              <%= label %>
            </span>
            <span class="col-start-2 whitespace-nowrap text-xs text-gray-500">
              <%= sub_label %>
            </span>
          <% end %>
        ERB

        private

        def apply_parent_classes
          html_options[:class] = parent_component.item_classes(class: html_options[:class])
          html_options[:form_class] = parent_component.form_item_classes(class: html_options[:form_class])
        end
      end

      class NestedMenuComponent < MenuDropdownComponent
        renders_one :icon
        renders_one :label
        renders_one :sub_label

        def initialize(placement:)
          super(placement: placement)
        end

        def wrapper_classes
          form_item_classes
        end

        erb_template <<-ERB
          <%= render Maglev::Uikit::DropdownComponent.new(placement: placement, wrapper_classes: wrapper_classes) do |dropdown| %>
            <% dropdown.with_trigger do %>
              <%= button_tag class: item_classes, data: { action: 'click->uikit-dropdown#toggle', 'uikit-dropdown-target': 'button' } do %>
                <%= render Maglev::Uikit::IconComponent.new(name: icon.to_s, size: '1.15rem', class_names: 'mr-2') if icon? %>
                <span class="whitespace-nowrap <%= 'col-start-2' unless icon? %>">
                  <%= label %>
                </span>
                <span class="col-start-2 whitespace-nowrap text-xs text-gray-500">
                  <%= sub_label %>
                </span>
              <% end %>
            <% end %>

            <div class="text-gray-800 grid grid-cols-[auto_1fr]">
              <% items.each do |item| %>
                <%= item %>
              <% end %>
            </div>
          <% end %>
        ERB
      end
    end
  end
end
