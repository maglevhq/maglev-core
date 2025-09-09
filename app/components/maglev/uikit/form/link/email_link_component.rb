class Maglev::Uikit::Form::Link::EmailLinkComponent < Maglev::Uikit::BaseComponent
  attr_reader :input_name, :link, :path

  # Value: { link_type:, link_id:, href:, text: }
  def initialize(input_name:, link:, path:)
    @input_name = input_name
    @link = link
    @path = path
  end
end