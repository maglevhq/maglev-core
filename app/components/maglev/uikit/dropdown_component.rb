# frozen_string_literal: true

module Maglev
  module Uikit
    class DropdownComponent < ViewComponent::Base
      renders_one :trigger

      attr_reader :placement

      def initialize(placement: 'bottom-start')
        @placement = placement
      end
    end
  end
end
