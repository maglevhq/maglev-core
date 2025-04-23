# frozen_string_literal: true

module Maglev
  module Content
    class Base
      include ::Maglev::Inspector

      extend Forwardable
      def_delegators :scope, :site, :config, :page

      attr_accessor :scope, :content, :setting

      # Scope can be either a section or a block
      def initialize(scope, content, setting)
        @scope = scope
        @content = content
        @setting = setting
      end

      # rubocop:disable Rails/OutputSafety
      def dom_data
        "data-maglev-id=\"#{tag_id}\"".html_safe
      end
      # rubocop:enable Rails/OutputSafety

      def tag_data
        { maglev_id: tag_id }
      end

      def tag_id
        "#{scope.id}.#{setting.id}"
      end

      def to_s
        content || ''
      end

      def tag(_view_context, _options)
        to_s
      end

      def asset_host
        case config.asset_host
        when nil
          nil
        when String
          config.asset_host
        when Proc
          instance_exec(site, &config.asset_host)
        end
      end

      private

      def inspect_fields
        %w[scope tag_id].map { |field| [field, send(field).inspect] }
      end
    end
  end
end
