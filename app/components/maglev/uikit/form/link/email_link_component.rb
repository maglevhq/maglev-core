class Maglev::Uikit::Form::Link::EmailLinkComponent < Maglev::Uikit::BaseComponent
  attr_reader :link, :path

  # Value: { link_type:, link_id:, href:, text: }
  def initialize(link:, path:)
    @link = link
    @path = path
  end
end