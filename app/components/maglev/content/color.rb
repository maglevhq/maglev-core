# frozen_string_literal: true

module Maglev
  module Content
    class Color < Base
      def dark?
        brightness < 128
      end

      def light?
        !dark?
      end

      def brightness
        r, g, b = content.match(/^#(..)(..)(..)$/).captures.map(&:hex)
        (r * 299 + g * 587 + b * 114) / 1000.0
      end
    end
  end
end
