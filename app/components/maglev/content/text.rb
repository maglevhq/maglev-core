# frozen_string_literal: true

module Maglev
  module Content
    class Text < Base
      def tag(view_context, options = {}, _content = nil)
        view_context.tag.public_send(
          options.delete(:html_tag)&.to_sym || tag_name,
          to_s,
          {
            data: (options.delete(:data) || {}).merge(tag_data)
          }.merge(options)
        )
      end

      private

      def tag_name
        setting.options[:html] && !setting.options[:line_break] ? :div : :span
      end
    end
  end
end
