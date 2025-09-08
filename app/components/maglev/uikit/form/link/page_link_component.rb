class Maglev::Uikit::Form::Link::PageLinkComponent < Maglev::Uikit::BaseComponent
  attr_reader :link, :path

  def initialize(link:, path:)
    @link = link
    @path = path
  end
end