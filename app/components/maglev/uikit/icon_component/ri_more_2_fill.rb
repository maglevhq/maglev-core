class Maglev::Uikit::IconComponent::RiMore2Fill < Maglev::Uikit::IconComponent::BaseComponent
  def call
    <<-SVG
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="fill-current" style="#{style}"><path d="M12 3c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm0 14c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm0-7c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z"/></svg>
    SVG
    .html_safe
  end
end