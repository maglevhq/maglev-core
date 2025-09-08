class Maglev::Uikit::Form::LinkComponentPreview < ViewComponent::Preview
  # @!group Variants
  def default
    render(Maglev::Uikit::Form::LinkComponent.new(
      name: 'link',
      path: '#',
      options: { label: 'Link', value: nil, placeholder: 'Assign a link by clicking here' }
    ))
  end

  def with_text
    render(Maglev::Uikit::Form::LinkComponent.new(
      name: 'link',
      path: '#',
      options: { label: 'Link', value: nil, with_text: true , placeholder: 'Assign a link by clicking here' }
    ))
  end

  def with_url_value
    render(Maglev::Uikit::Form::LinkComponent.new(
      name: 'link',
      path: '#',
      options: { label: 'Link', value: { link_type: 'url', href: 'https://www.google.com' } }
    ))
  end

  def with_email_value
    render(Maglev::Uikit::Form::LinkComponent.new(
      name: 'link',
      path: '#',
      options: { label: 'Link', value: { link_type: 'email', href: 'did@maglev.dev' } }
    ))
  end

  def with_page_value
    render(Maglev::Uikit::Form::LinkComponent.new(
      name: 'link',
      path: '#',
      options: { label: 'Link', value: { link_type: 'page', link_id: 1, href: '/foo/bar' } }
    ))
  end

  def with_error
    render(Maglev::Uikit::Form::LinkComponent.new(
      name: 'link',
      path: '#',
      options: { label: 'Link', value: nil, error: 'Error' }
    ))
  end

  # @!endgroup
end