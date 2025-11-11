# frozen_string_literal: true

module Maglev
  module Uikit
    class DropdownComponentPreview < ViewComponent::Preview
      def default
        render_with_template
      end

      def with_icon_button
        render_with_template
      end

      def inner_dropdown
        render_with_template
      end
    end
  end
end
