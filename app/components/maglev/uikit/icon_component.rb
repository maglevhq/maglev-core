class Maglev::Uikit::IconComponent < ViewComponent::Base
  attr_reader :name, :size, :class_names

  def initialize(name:, size: '1.25rem', class_names: nil)
    @name = name
    @size = size
    @class_names = class_names
  end

  def call
    begin
      klass_name = "maglev/uikit/icon_component/#{name}".classify.constantize
      render klass_name.new(size: size, class_names: class_names)
    rescue NameError
      raise "Icon component #{name} not found"
    end
  end
end