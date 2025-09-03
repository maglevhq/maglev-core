class Maglev::Inputs::Forms::SectionFormComponent < ViewComponent::Base
  attr_reader :section, :path

  def initialize(section:, path:)
    @section = section
    @path = path
  end
end