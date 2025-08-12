class Maglev::Uikit::PageLayoutComponentPreview < ViewComponent::Preview
  def default
    render(Maglev::Uikit::PageLayoutComponent.new) do |component|
      component.with_title do
        "Page Title"
      end
      component.with_description do
        "Page Description"
      end

      10.times.map do |i|
        <<~HTML
          <p class="mb-4">
            Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quos.
          </p>
        HTML
      end.join.html_safe
    end
  end
end