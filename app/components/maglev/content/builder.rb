# frozen_string_literal: true

module Maglev
  module Content
    module Builder
      def build(scope, content, setting)
        setting.content_class.new(scope, content, setting)
      end

      module_function :build
    end
  end
end
