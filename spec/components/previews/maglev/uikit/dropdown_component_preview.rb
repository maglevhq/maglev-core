class Maglev::Uikit::DropdownComponentPreview < ViewComponent::Preview
  def default
    render(Maglev::Uikit::DropdownComponent.new) do |component|
      component.with_trigger do
        <<-HTML
          <button data-action="click->uikit-dropdown#toggle" data-uikit-dropdown-target="button" class="bg-gray-800 text-white px-4 py-2 rounded-md cursor-pointer">Click me</button>
        HTML
        .html_safe
      end
      <<-HTML
        <p>Hello world</p>
      HTML
      .html_safe
    end
  end
end