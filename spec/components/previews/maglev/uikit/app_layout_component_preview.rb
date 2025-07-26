class Maglev::Uikit::AppLayoutComponentPreview < ViewComponent::Preview
  def default
    render Maglev::Uikit::AppLayoutComponent.new
  end
end