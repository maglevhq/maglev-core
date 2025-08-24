class Maglev::Uikit::IconButtonComponent < Maglev::Uikit::BaseComponent
  attr_reader :icon_name, :options

  def initialize(icon_name: nil, dark: false, **options)
    @icon_name = icon_name
    @dark = dark
    @options = options
  end

  def button_classes(...)
    helpers.maglev_icon_button_classes(...)
  end

  def dark?
    @dark
  end
end