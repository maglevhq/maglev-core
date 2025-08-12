class Maglev::Uikit::TabsComponent < Maglev::Uikit::BaseComponent
  renders_many :tabs, -> (label:, active: false, &block) do
    Tab.new(self, label:, active:, block:)
  end

  attr_reader :active_tab, :container_classes

  def initialize(container_classes: nil)
    @container_classes = container_classes
  end

  def label_classes(...)
    class_variants(
      base: 'relative py-1 pb-0 px-4 block focus:outline-none border-b-2 z-10 font-medium hover:text-editor-primary',
      variants: {
        active: 'text-editor-primary border-editor-primary',
        '!active': 'text-gray-500 border-transparent'
      }
    ).render(...)
  end

  def before_render
    return if tabs.find(&:active?)
    tabs.first.active = true
  end

  class Tab < Maglev::Uikit::BaseComponent
    attr_reader :label, :block

    def initialize(component, label:, active:, block:)
      @component = component
      @label = label
      @active = active
      @block = block      
    end

    def active?
      @active
    end

    def active=(value)
      @active = value
    end
  end
end