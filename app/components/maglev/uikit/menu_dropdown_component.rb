class Maglev::Uikit::MenuDropdownComponent < Maglev::Uikit::BaseComponent
  renders_one :trigger
  renders_many :items

  attr_reader :icon_name

  def initialize(icon_name: nil)
    @icon_name = icon_name
  end

  def item_classes(...)
    class_variants(
      base: 'flex items-center px-4 py-4 hover:bg-gray-100 transition-colors duration-200 focus:outline-none cursor-pointer flex-1',      
    ).render(...)
  end

  def form_item_classes(...)
    class_variants(
      base: 'flex items-center focus:outline-none cursor-pointer',
    ).render(...)
  end
end