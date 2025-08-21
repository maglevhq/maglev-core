class Maglev::Uikit::AppLayout::Topbar::PageInfoComponent < ViewComponent::Base
  attr_reader :page, :paths, :live_page_url

  def initialize(page:, paths:, live_page_url:)
    @page = page
    @paths = paths
    @live_page_url = live_page_url
  end

  def icon_name
    page.index? ? 'home' : 'file'
  end
end