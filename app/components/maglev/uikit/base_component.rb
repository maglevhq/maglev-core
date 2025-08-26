# frozen_string_literal: true

require 'class_variants'

module Maglev
  module Uikit
    class BaseComponent < ViewComponent::Base
      include ClassVariants::ActionView::Helpers

      def button_class_names(...)
        helpers.maglev_button_classes(...)
      end
    end
  end
end
