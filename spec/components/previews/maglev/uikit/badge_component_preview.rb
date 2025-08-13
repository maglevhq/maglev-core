class Maglev::Uikit::BadgeComponentPreview < ViewComponent::Preview
  # @!group Variants
  def default
    render Maglev::Uikit::BadgeComponent.new(color: :green).with_content('Success')
  end

  def different_color
    render Maglev::Uikit::BadgeComponent.new(color: :red).with_content('Error')
  end

  def with_icon
    render Maglev::Uikit::BadgeComponent.new(color: :green, icon_name: 'ri_checkbox_circle_fill').with_content('Success')
  end

  def with_disappearance
    render Maglev::Uikit::BadgeComponent.new(color: :green, disappear_after: 5.seconds).with_content('Success')
  end

  # @!endgroup
end