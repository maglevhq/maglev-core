class Maglev::Uikit::ImageLibrary::CardComponent < Maglev::Uikit::BaseComponent
  attr_reader :id, :image_url, :filename, :width, :height, :byte_size, :delete_path, :picker_attributes

  def initialize(id:, image_url:, filename:, width:, height:, byte_size:, delete_path:, picker_attributes: nil)
    @id = id
    @image_url = image_url
    @filename = filename
    @width = width
    @height = height
    @byte_size = byte_size
    @delete_path = delete_path
    @picker_attributes = picker_attributes
  end

  def picker_event_payload
    {
      source: picker_attributes[:source],
      image: {
        id: id,
        filename: filename,
        image_url: image_url,
        width: width,
        height: height,
        byte_size: byte_size
      }
    }.to_json
  end

  def picker_event_name
    "image-selected-#{picker_attributes[:source]}"
  end
end