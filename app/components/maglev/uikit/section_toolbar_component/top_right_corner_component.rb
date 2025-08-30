class Maglev::Uikit::SectionToolbarComponent::TopRightCornerComponent < Maglev::Uikit::BaseComponent
  attr_reader :paths, :options
  
  def initialize(paths:, options:)
    @paths = paths
    @options = options
  end
end