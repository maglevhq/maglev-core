# frozen_string_literal: true

module Maglev
  module Content
    class Base
      attr_accessor :scope, :content, :setting

      # Scope can be either a section or a block
      def initialize(scope, content, setting)
        @scope = scope
        @content = content
        @setting = setting
      end

      def dom_data
        "data-maglev-id=\"#{scope.id}.#{setting.id}\"".html_safe
      end

      def to_s
        @content || ''
      end
    end
  end
end
