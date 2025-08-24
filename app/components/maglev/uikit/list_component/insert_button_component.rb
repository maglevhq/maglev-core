class Maglev::Uikit::ListComponent::InsertButtonComponent < Maglev::Uikit::BaseComponent
  attr_reader :link, :insert_at

  def initialize(link:, insert_at:)
    @link = link
    @insert_at = insert_at
  end

  def link_url
    link[:url]
  end

  def link_data
    link[:data] || {}
  end

  def top?
    @insert_at == "top"
  end

  def bottom?
    @insert_at == "bottom"
  end

  def wrapper_classes(...)
    class_variants(
      base: "absolute left-0 w-full h-7 group bg-red-500/0 z-10",
      variants: {
        top: "-top-5",
        bottom: "-bottom-5"
      },
      defaults: {
        top: top?,
        bottom: bottom?
      }
    ).render(...)
  end
end