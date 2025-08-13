class Maglev::Uikit::Form::CheckboxComponent < ViewComponent::Base
  attr_reader :label, :name, :placeholder

  def initialize(label:, name:, checked: false, placeholder: nil)
    @label = label
    @name = name
    @checked = checked    
    @placeholder = placeholder
  end

  def checked?
    @checked
  end

  def dom_id
    name.to_s.parameterize.underscore
  end
end