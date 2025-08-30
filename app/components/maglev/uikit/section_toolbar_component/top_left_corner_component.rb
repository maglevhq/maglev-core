class Maglev::Uikit::SectionToolbarComponent::TopLeftCornerComponent < Maglev::Uikit::BaseComponent
  attr_reader :label

  def initialize(label:)
    @label = label
  end
end