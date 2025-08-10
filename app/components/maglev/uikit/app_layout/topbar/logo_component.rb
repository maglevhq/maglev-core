class Maglev::Uikit::AppLayout::Topbar::LogoComponent < ViewComponent::Base
  attr_reader :page

  def initialize(page:)
    @page = page
  end

  def editor_root_path
    helpers.maglev.editor_real_root_path(locale: I18n.locale, page_id: page.id)
  end
end