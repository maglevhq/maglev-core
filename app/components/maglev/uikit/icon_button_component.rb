# frozen_string_literal: true

module Maglev
  module Uikit
    class IconButtonComponent < Maglev::Uikit::BaseComponent
      attr_reader :icon_name, :options

      def initialize(icon_name: nil, **options)
        @icon_name = icon_name
        @options = options
      end

      def button_classes(...)
        helpers.maglev_icon_button_classes(...)
      end
    end
  end
end
