class Maglev::Uikit::Form::TextFieldComponent < ViewComponent::Base
  attr_reader :label, :name, :value, :hint, :placeholder, :error

  def initialize(label:, name:, value: nil, placeholder: nil, error: nil)
    @label = label
    @name = name
    @value = value
    @hint = hint
    @placeholder = placeholder
    @error = error
  end

  def dom_id
    name.to_s.parameterize.underscore
  end
end