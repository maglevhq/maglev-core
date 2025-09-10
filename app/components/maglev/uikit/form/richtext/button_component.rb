class Maglev::Uikit::Form::Richtext::ButtonComponent < ViewComponent::Base
  attr_reader :name, :icon
  
  def initialize(name:, icon:)
    @name = name
    @icon = icon
  end
end