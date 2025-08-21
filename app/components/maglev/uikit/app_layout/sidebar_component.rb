class Maglev::Uikit::AppLayout::SidebarComponent < ViewComponent::Base
  renders_many :links, 'Maglev::Uikit::AppLayout::Sidebar::LinkComponent'
end