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

      def tag_data
        { maglev_id: "#{scope.id}.#{setting.id}" }
      end

      delegate :site, to: :scope

      def to_s
        @content || ''
      end

      def tag
        to_s
      end
    end
  end
end
