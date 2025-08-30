class Maglev::Uikit::SectionToolbarComponent::BottomComponent < Maglev::Uikit::BaseComponent
  attr_reader :paths, :options

  def initialize(paths:, options:)
    @paths = paths
    @options = options
  end

  def insert_button?
    options[:insert_button].nil? || !!options[:insert_button]
  end

  def button_classes
    %(
      bg-editor-primary
      pointer-events-auto
      flex
      items-center
      justify-center
      h-8
      w-8
      rounded-full
      text-white/75
      hover:text-white
      relative
      cursor-pointer
      top-4
    )
  end
end