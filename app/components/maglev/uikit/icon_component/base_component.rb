class Maglev::Uikit::IconComponent::BaseComponent < ViewComponent::Base
  attr_reader :size, :class_names

  def initialize(size: '1.25rem', class_names: nil)
    @size = size
    @class_names = class_names
  end

  def style
    "width: #{size}; height: #{size};"
  end

  def final_class_names
    helpers.class_names(*class_names, 'fill-current')
  end
end