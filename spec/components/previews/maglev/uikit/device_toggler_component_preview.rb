# frozen_string_literal: true

module Maglev
  module Uikit
    class DeviceTogglerComponentPreview < ViewComponent::Preview
      def default
        render(Maglev::Uikit::DeviceTogglerComponent.new)
      end
    end
  end
end
