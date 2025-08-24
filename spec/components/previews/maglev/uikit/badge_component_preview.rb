class Maglev::Uikit::BadgeComponentPreview < ViewComponent::Preview
  # @!group Variants
  def default
    render Maglev::Uikit::BadgeComponent.new(color: :green).with_content('Success')
  end

  def different_color
    render Maglev::Uikit::BadgeComponent.new(color: :red).with_content('Error')
  end

  def with_icon
    render Maglev::Uikit::BadgeComponent.new(color: :green, icon_name: 'checkbox_circle').with_content('Success')
  end

  def with_disappearance
    render Maglev::Uikit::BadgeComponent.new(color: :green, disappear_after: 5.seconds).with_content('Success')
  end

  def with_long_text
    render Maglev::Uikit::BadgeComponent.new(color: :green, icon_name: 'checkbox_circle', class_names: 'w-32').with_content('A very long text, super long')
  end
  # @!endgroup
end