# frozen_string_literal: true

module Maglev
  module Content
    class Text < Base
      # rubocop:disable Rails/OutputSafety
      def tag(view_context, options = {})
        view_context.tag.public_send(
          options.delete(:html_tag)&.to_sym || tag_name,
          to_s.html_safe,
          **{
            data: (options.delete(:data) || {}).merge(tag_data)
          }.merge(options)
        )
      end
      # rubocop:enable Rails/OutputSafety

      private

      def tag_name
        setting.options[:html] && !setting.options[:line_break] ? :div : :span
      end
    end
  end
end
