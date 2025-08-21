class Maglev::Uikit::Form::SearchFormComponentPreview < ViewComponent::Preview
  # @!group Variants

  def default
    render(Maglev::Uikit::Form::SearchFormComponent.new(name: 'q', value: '', search_path: '#', placeholder: 'Search for a page'))
  end

  def with_value
    render(Maglev::Uikit::Form::SearchFormComponent.new(name: 'q', value: 'test', search_path: '#', placeholder: 'Search for a page'))
  end

  # @!endgroup
end