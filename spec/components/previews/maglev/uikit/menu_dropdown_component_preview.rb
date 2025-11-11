# frozen_string_literal: true

module Maglev
  module Uikit
    class MenuDropdownComponentPreview < ViewComponent::Preview
      def default
        render_with_template
      end

      def custom_button
        render_with_template
      end

      def nested_menu
        render_with_template
      end
    end
  end
end
