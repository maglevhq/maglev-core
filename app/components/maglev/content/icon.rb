# frozen_string_literal: true

module Maglev
  module Content
    class Icon < Base
      def_delegators :icon_class, :blank?

      def icon_class
        @content
      end

      def to_s
        @content
      end

      def tag(view_context, options = {})
        view_context.content_tag(:i, '',
                                 {
                                   class: [options.delete(:class), icon_class].compact.join(' '),
                                   data: (options.delete(:data) || {}).merge(tag_data)
                                 }.merge(options),
                                 false)
      end
    end
  end
end
