class Maglev::Uikit::SectionToolbarComponent < ViewComponent::Base
  attr_reader :id, :label, :paths, :options

  def initialize(id:, label:, paths:, options: {})
    @id = id
    @label = label
    @paths = paths
    @options = options
  end
end