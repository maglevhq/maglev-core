class Maglev::Uikit::ModalComponentPreview < ViewComponent::Preview
  def default
    render_with_template
  end

  def with_form
    render_with_template(locals: { user: MockedUser.new(name: 'John Doe') })
  end

  def with_notification
    render_with_template
  end

  class MockedUser
    include ActiveModel::API
    attr_accessor :name
  end
end