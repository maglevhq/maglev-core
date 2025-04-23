# frozen_string_literal: true

module Maglev
  module Content
    class Link < Base
      def href
        link[:href]
      end

      def text
        link[:text]
      end

      def with_text?
        !!setting.options[:with_text]
      end

      def open_new_window?
        !!link[:open_new_window]
      end

      def target_blank
        open_new_window? ? '_blank' : nil
      end

      def active?
        link[:link_type] == 'page' && link[:link_id] == page.id
      end

      def to_s
        href
      end

      def tag(view_context, options = {}, &block)
        captured_content = view_context.capture(&block) if block_given?
        view_context.link_to(
          captured_content || text_tag(view_context),
          href,
          {
            data: (options.delete(:data) || {}).merge(tag_data),
            target: target_blank
          }.merge(options)
        )
      end

      private

      def link
        @link ||= if content.is_a?(String)
                    { href: content, link_type: 'url', open_new_window: false }
                  elsif content
                    content
                  else
                    {}
                  end.symbolize_keys
      end

      # rubocop:disable Rails/OutputSafety
      def text_tag(view_context)
        view_context.tag.span(text, **{ data: { maglev_id: "#{tag_id}.text" } }).html_safe
      end
      # rubocop:enable Rails/OutputSafety
    end
  end
end
