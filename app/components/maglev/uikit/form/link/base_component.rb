class Maglev::Uikit::Form::Link::BaseComponent < Maglev::Uikit::BaseComponent
  attr_reader :input_name, :link, :path

  def initialize(input_name:, link:, path:)
    @input_name = input_name
    @link = link
    @path = path
  end
end