class Maglev::Uikit::AppLayout::LayoutComponent < ViewComponent::Base
  renders_one :header
  renders_one :sidebar, ->() { Maglev::Uikit::AppLayout::SidebarComponent.new }
  
  attr_reader :page

  def initialize(page:)
    @page = page
  end

  def editor_root_path
    helpers.maglev.editor_real_root_path(locale: I18n.locale, page_id: page.id)
  end
end