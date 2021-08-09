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

      def to_s
        href
      end

      def tag(view_context, options = {}, content = nil)
        view_context.link_to(
          with_text? ? text_tag(view_context) : content,
          href,
          {
            data: (options.delete(:data) || {}).merge(tag_data),
            target: open_new_window? ? '_blank' : nil
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
        view_context.tag.span(text, { data: { maglev_id: "#{tag_id}.text" } }).html_safe
      end
      # rubocop:enable Rails/OutputSafety
    end
  end
end
