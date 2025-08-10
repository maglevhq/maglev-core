class Maglev::Uikit::AppLayout::Sidebar::LinkComponent < Maglev::Uikit::BaseComponent

  attr_reader :path, :icon, :icon_size, :active

  def initialize(path:, icon:, icon_size: '1.5rem', active: false, position: :top)
    @path = path
    @icon = icon
    @icon_size = icon_size
    @active = active
    @position = position
  end

  def active?
    @active
  end

  def top?
    @position == :top
  end

  def link_classes(...)
    class_variants(
      base: 'flex justify-center py-5 -ml-4 -mr-4 hover:bg-editor-primary/5 transition-colors duration-200',
      variants: {
        active: 'bg-editor-primary/5',
        '!active': 'bg-white'
      }
    ).render(...)
  end
end