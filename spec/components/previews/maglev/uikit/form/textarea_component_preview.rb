class Maglev::Uikit::Form::TextareaComponentPreview < ViewComponent::Preview
  # @!group Variants
  def default
    render(Maglev::Uikit::Form::TextareaComponent.new(
      label: 'Label',
      name: 'name',
      value: 'Value'
    ))
  end

  def with_value
    render(Maglev::Uikit::Form::TextareaComponent.new(
      label: 'Label',
      name: 'name',
      value: 'Lorem ipsum dolor sit amet'
    ))
  end

  def with_max_length
    render(Maglev::Uikit::Form::TextareaComponent.new(
      label: 'Label',
      name: 'name',
      value: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quos.',
      max_length: 10,
      rows: 5
    ))
  end

  # @!endgroup
end