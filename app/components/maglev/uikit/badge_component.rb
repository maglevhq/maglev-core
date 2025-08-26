# frozen_string_literal: true

module Maglev
  module Uikit
    class BadgeComponent < Maglev::Uikit::BaseComponent
      erb_template <<~ERB
        <span class="<%= badge_classes(color: color) %>" data-controller="disappearance" data-disappearance-after-value="<%= disappear_after %>">#{'      '}
          <% if icon_name.present? %>
            <%= render Maglev::Uikit::IconComponent.new(name: icon_name, size: '0.85rem', class_names: 'shrink-0') %>
          <% end %>
          <span class="truncate">
            <%= content %>#{'      '}
          </span>
        </span>
      ERB

      attr_reader :color, :icon_name, :disappear_after, :class_names

      def initialize(color:, icon_name: nil, disappear_after: nil, class_names: nil)
        @color = color
        @icon_name = icon_name
        @disappear_after = disappear_after.to_f
        @class_names = class_names
      end

      def badge_classes(**args)
        class_variants(
          base: 'inline-flex items-center rounded-full px-1.5 py-0.5 text-xs font-medium gap-1',
          variants: {
            color: {
              green: 'bg-green-100 text-green-700',
              red: 'bg-red-100 text-red-700',
              gray: 'bg-gray-100 text-gray-700'
            }
          }
        ).render(**args, class: class_names)
      end
    end
  end
end
