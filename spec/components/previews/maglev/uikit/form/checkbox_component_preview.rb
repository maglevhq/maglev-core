class Maglev::Uikit::Form::CheckboxComponentPreview < ViewComponent::Preview
  # @!group Variants

  def default
    render(Maglev::Uikit::Form::CheckboxComponent.new(
      label: 'Label', 
      name: 'user[active]'
      )
    )
  end

  def checked
    render(Maglev::Uikit::Form::CheckboxComponent.new(
      label: 'Label', 
      name: 'user[active]',
      checked: true
      )
    )
  end

  def with_placeholder
    render(Maglev::Uikit::Form::CheckboxComponent.new(
      label: 'Label', 
      name: 'user[active]',
      placeholder: 'Lorem ipsum dolor sit amet'
      )
    )
  end

  # @!endgroup
end