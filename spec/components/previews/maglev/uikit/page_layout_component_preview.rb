# frozen_string_literal: true

module Maglev
  module Uikit
    class PageLayoutComponentPreview < ViewComponent::Preview
      # Top-right close uses link_to(back_path); nil becomes url_for({}) and breaks under Lookbook at "/".
      PAGE_LAYOUT_PREVIEW_LOCALS = { page_layout_back_path: '#' }.freeze

      def default
        render_with_template(locals: PAGE_LAYOUT_PREVIEW_LOCALS)
      end

      def with_footer
        render_with_template(locals: PAGE_LAYOUT_PREVIEW_LOCALS)
      end

      def with_breadcrumbs
        render_with_template(locals: PAGE_LAYOUT_PREVIEW_LOCALS)
      end

      def with_notification
        render_with_template(locals: PAGE_LAYOUT_PREVIEW_LOCALS)
      end

      def with_back_link
        render_with_template(locals: PAGE_LAYOUT_PREVIEW_LOCALS)
      end
    end
  end
end
