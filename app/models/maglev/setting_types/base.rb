# frozen_string_literal: true

module Maglev
  module SettingTypes
    class Base
      def cast_value(value)
        value
      end

      # rubocop:disable Lint/UnusedMethodArgument
      def default_for(label:, default:)
        default
      end
      # rubocop:enable Lint/UnusedMethodArgument

      def content_class
        @content_class ||= "Maglev::Content::#{self.class.name.demodulize}".constantize
      end
    end
  end
end
