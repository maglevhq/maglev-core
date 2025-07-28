class Maglev::Uikit::IconComponent < ViewComponent::Base
  def initialize(name:)
    @name = name
  end

  def call
    begin
      class_name = "maglev/uikit/icon_component/#{@name}".classify.constantize
      render class_name.new
    rescue NameError
      raise "Icon component #{@name} not found"
    end
  end
end