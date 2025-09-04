# frozen_string_literal: true

module Maglev
  module Inputs
    class InputBaseComponent < ViewComponent::Base
      attr_reader :setting, :value, :scope

      def initialize(setting:, value:, scope:)
        @setting = setting
        @value = value
        @scope = scope
      end

      def input_name
        "#{scope}[#{setting.id}]"
      end
    end
  end
end
