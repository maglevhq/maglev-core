class Maglev::Uikit::TabsComponent < Maglev::Uikit::BaseComponent
  renders_many :tabs, -> (label:, active: false, &block) do
    Tab.new(self, label:, active:, block:)
  end

  attr_reader :container_classes, :active_tab, :active_tab_index

  def initialize(container_classes: nil, active_tab_index: nil)
    @container_classes = container_classes
    @active_tab_index = active_tab_index
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
    @active_tab = tabs.find(&:active?) || tabs[active_tab_index.to_i]
    @active_tab.active = true
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