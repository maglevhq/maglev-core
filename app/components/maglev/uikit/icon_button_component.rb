class Maglev::Uikit::IconButtonComponent < Maglev::Uikit::BaseComponent
  attr_reader :icon_name, :options

  def initialize(icon_name: nil, dark: false, **options)
    @icon_name = icon_name
    @dark = dark
    @options = options
  end

  def button_classes(...)
    class_variants(
      base: 'h-7 w-7 flex items-center justify-center rounded-full focus:outline-none transition-colors duration-200 cursor-pointer',
      variants: {
        dark: 'bg-gray-600 text-gray-200 hover:bg-gray-900 hover:text-gray-100',
        '!dark': 'bg-gray-600/0 text-gray-800 hover:bg-gray-600/10 hover:text-gray-900'
      }
    ).render(...)
  end

  def dark?
    @dark
  end
end