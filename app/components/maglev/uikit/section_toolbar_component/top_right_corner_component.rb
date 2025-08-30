class Maglev::Uikit::SectionToolbarComponent::TopRightCornerComponent < Maglev::Uikit::BaseComponent
  attr_reader :paths, :options
  
  def initialize(paths:, options:)
    @paths = paths
    @options = options
  end

  def has_blocks?
    !!options[:has_blocks]
  end

  def button_classes
    %(
      relative
      bg-white
      z-50
      rounded-full
      shadow-xl
      h-8
      w-8
      flex
      items-center
      justify-center
      text-gray-700
      pointer-events-auto
      hover:text-black
      cursor-pointer
    )
  end
end