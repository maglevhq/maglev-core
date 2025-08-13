class Maglev::Uikit::Form::TextFieldComponentPreview < ViewComponent::Preview
  # @!group Variants

  def default
    render(Maglev::Uikit::Form::TextFieldComponent.new(
      label: 'Label', 
      name: 'user[name]',
      )
    )
  end

  def with_placeholder
    render(Maglev::Uikit::Form::TextFieldComponent.new(
      label: 'Label', 
      name: 'user[name]',
      placeholder: 'Placeholder'
      )
    )
  end

  def with_value
    render(Maglev::Uikit::Form::TextFieldComponent.new(
      label: 'Label', 
      name: 'user[name]',
      value: 'Lorem ipsum dolor sit amet'
      )
    )
  end

  def with_error
    render(Maglev::Uikit::Form::TextFieldComponent.new(
      label: 'Label', 
      name: 'user[name]',
      error: 'must be present'
      )
    )
  end

  # @!endgroup
  
end