# frozen_string_literal: true

module Maglev
  module Content
    class Checkbox < Base
      def true?
        !!content
      end

      def false?
        !true?
      end

      def to_s
        content
      end
    end
  end
end
