# frozen_string_literal: true

module Maglev
  module Uikit
    class IconButtonComponentPreview < ViewComponent::Preview
      def default
        render(Maglev::Uikit::IconButtonComponent.new(icon_name: 'more_2', dark: false,
                                                      data: { action: 'click->uikit-dropdown#toggle' }))
      end
    end
  end
end
