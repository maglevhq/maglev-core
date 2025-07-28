class Maglev::Uikit::DrawerComponent < ViewComponent::Base
  def initialize(title: nil, icon: nil, open: true)
    @title = title
    @icon = icon
    @open = open
  end

  def render?
    @open
  end
end