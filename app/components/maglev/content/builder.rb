# frozen_string_literal: true

module Maglev
  module Content
    module Builder
      def build(scope, content, setting)
        klass = find_klass(setting.type.to_sym)

        raise "[Maglev] Unknown setting type: #{setting.type}" unless klass

        klass.new(scope, content, setting)
      end

      def find_klass(type)
        Maglev::Content.const_get(type.to_s.camelize)
      end

      module_function :build, :find_klass
    end
  end
end
