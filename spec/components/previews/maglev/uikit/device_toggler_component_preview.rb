class Maglev::Uikit::DeviceTogglerComponentPreview < ViewComponent::Preview
  def default
    render(Maglev::Uikit::DeviceTogglerComponent.new)
  end
end