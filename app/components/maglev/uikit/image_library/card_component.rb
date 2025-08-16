class Maglev::Uikit::ImageLibrary::CardComponent < Maglev::Uikit::BaseComponent
  attr_reader :image_url, :filename, :width, :height, :byte_size, :delete_url

  def initialize(image_url:, filename:, width:, height:, byte_size:, delete_url:)
    @image_url = image_url
    @filename = filename
    @width = width
    @height = height
    @byte_size = byte_size
    @delete_url = delete_url
  end
end