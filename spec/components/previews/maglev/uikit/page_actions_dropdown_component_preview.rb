class Maglev::Uikit::PageActionsDropdownComponentPreview < ViewComponent::Preview
  def default
    render(Maglev::Uikit::PageActionsDropdownComponent.new(
      paths: paths,
      live_url: 'https://www.google.com'
    ))
  end

  def without_some_actions
    render(Maglev::Uikit::PageActionsDropdownComponent.new(
      paths: paths,
      live_url: 'https://www.google.com',
      without_actions: [:delete]
    ))
  end

  private

  def paths
    {
      edit: '#',
      clone: '#',
      delete: '#',
      update: '#'
    }
  end
end