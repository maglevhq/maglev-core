# frozen_string_literal: true

module Maglev
  module Uikit
    class ButtonComponentPreview < ViewComponent::Preview
      # @!group Variants

      # @param size select { choices: [medium, big] }
      # @param disabled toggle
      def primary(size: :medium, disabled: false)
        render_with_template(template: 'maglev/uikit/button_component_preview/default',
                             locals: { color: :primary, size: size, disabled: disabled })
      end

      # @param size select { choices: [medium, big] }
      # @param disabled toggle
      def secondary(size: :medium, disabled: false)
        render_with_template(template: 'maglev/uikit/button_component_preview/default',
                             locals: { color: :secondary, size: size, disabled: disabled })
      end

      # @!endgroup
    end
  end
end
