class Maglev::Uikit::ImageLibrary::CardComponent < Maglev::Uikit::BaseComponent
  attr_reader :image_url, :filename, :width, :height, :byte_size, :delete_path

  def initialize(image_url:, filename:, width:, height:, byte_size:, delete_path:)
    @image_url = image_url
    @filename = filename
    @width = width
    @height = height
    @byte_size = byte_size
    @delete_path = delete_path
  end
end