# frozen_string_literal: true

module Maglev
  module Content
    class CollectionItem < Base
      def exists?
        item.present?
      end

      def to_s
        item.inspect
      end

      def item
        (content || {})[:item]
      end

      def tag(view_context, options = {}, &block)
        return unless item && block_given?

        view_context.tag.public_send(
          options.delete(:html_tag)&.to_sym || :div,
          view_context.capture(item, &block),
          **{ data: (options.delete(:data) || {}).merge(tag_data) }.merge(options)
        )
      end
    end
  end
end
