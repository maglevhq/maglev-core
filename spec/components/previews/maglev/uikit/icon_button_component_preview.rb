class Maglev::Uikit::IconButtonComponentPreview < ViewComponent::Preview
  def default
    render(Maglev::Uikit::IconButtonComponent.new(icon_name: "more_2", dark: false, data: { action: "click->uikit-dropdown#toggle" }))
  end
end