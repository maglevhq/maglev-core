# frozen_string_literal: true

module Maglev
  module Uikit
    class PageLayoutComponentPreview < ViewComponent::Preview
      def default
        render_with_template
      end

      def with_footer
        render_with_template
      end

      def with_notification
        render_with_template
      end
    end
  end
end
