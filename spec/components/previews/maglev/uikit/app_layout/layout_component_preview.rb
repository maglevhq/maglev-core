class Maglev::Uikit::AppLayout::LayoutComponentPreview < ViewComponent::Preview
  layout 'preview_component_full_screen'

  def default
    page = Maglev::Page.new(id: 1,title: 'Welcome!', path: 'index')
    render_with_template(locals: { page: })
  end

  def without_bottom_actions
    page = Maglev::Page.new(id: 1,title: 'Welcome!', path: 'index')
    render_with_template(locals: { page: })
  end
end