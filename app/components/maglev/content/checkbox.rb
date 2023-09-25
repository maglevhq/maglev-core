# frozen_string_literal: true

module Maglev
  module Content
    class Checkbox < Base
      def true?
        !!cast_content
      end

      def false?
        !true?
      end

      def to_s
        content
      end

      private

      def cast_content
        @cast_content ||= ActiveModel::Type::Boolean.new.cast(content)
      end
    end
  end
end
