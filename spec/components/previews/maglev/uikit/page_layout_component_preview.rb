class Maglev::Uikit::PageLayoutComponentPreview < ViewComponent::Preview
  def default
    render_with_template
  end

  def with_footer
    render_with_template
  end

  def with_notification
    render_with_template
  end
end