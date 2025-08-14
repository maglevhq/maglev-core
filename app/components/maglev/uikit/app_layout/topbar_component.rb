class Maglev::Uikit::AppLayout::TopbarComponent < ViewComponent::Base
  renders_one :logo, ->() { Maglev::Uikit::AppLayout::Topbar::LogoComponent.new(page: page) }
  renders_one :page_info

  attr_reader :page

  def initialize(page:)
    @page = page
  end
end