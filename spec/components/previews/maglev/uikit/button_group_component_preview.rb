class Maglev::Uikit::ButtonGroupComponentPreview < ViewComponent::Preview
  # @!group Variants

  # @param color select { choices: [primary, secondary] }
  # @param size select { choices: [medium] }
  def default(color: :primary, size: :medium)
    render_with_template(template: 'maglev/uikit/button_group_component_preview/default', locals: { color: color, size: size })
  end

  # @param color select { choices: [primary, secondary] }
  # @param size select { choices: [medium] }
  def with_dropdown(color: :primary, size: :medium)
    render_with_template(template: 'maglev/uikit/button_group_component_preview/with_dropdown', locals: { color: color, size: size })
  end
  # @!endgroup
end