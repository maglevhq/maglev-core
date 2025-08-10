class Maglev::Uikit::AppLayout::Topbar::PageInfoComponent < ViewComponent::Base
  attr_reader :page

  def initialize(page:)
    @page = page
  end

  def icon_name
    page.index? ? 'home_4_line' : 'ri_file_line'
  end
end