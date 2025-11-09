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
      # @param form_state select { choices: [default, pending, success, error] }
      def primary_in_a_form(size: :medium, form_state: :default)
        render_with_template(locals: { color: :primary, size: size, form_state: form_state })
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
