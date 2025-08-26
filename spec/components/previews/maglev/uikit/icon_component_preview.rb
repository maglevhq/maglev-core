# frozen_string_literal: true

module Maglev
  module Uikit
    class IconComponentPreview < ViewComponent::Preview
      def default
        render_with_template(locals: {
                               list: icon_list
                             })
      end

      private

      def icon_list
        Maglev::Uikit::IconComponent::ICONS.keys
      end
    end
  end
end
