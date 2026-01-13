# frozen_string_literal: true

module Maglev
  module Uikit
    class DropdownComponent < ViewComponent::Base
      renders_one :trigger

      attr_reader :placement

      def initialize(placement: 'bottom-start', wrapper_classes: nil)
        @wrapper_classes = wrapper_classes
        @placement = placement
      end

      def wrapper_classes
        helpers.class_names('relative', @wrapper_classes)
      end
    end
  end
end
