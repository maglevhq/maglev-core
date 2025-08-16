class Maglev::Uikit::ImageLibrary::CardComponentPreview < ViewComponent::Preview
  # @!group Variants
  def default
    render_with_template(locals: { 
      image_url: '/images/img-1.jpg',
      filename: 'Image 1',
      width: 1920,
      height: 1080,
      byte_size: 217021
     })    
  end

  def with_vertical_image
    render_with_template(
      template: 'maglev/uikit/image_library/card_component_preview/default', 
      locals: { 
        image_url: '/images/img-2.jpg',
        filename: 'Image 2',
        width: 500,
        height: 805,
        byte_size: 5019
      }
    )
  end

  def with_square_image
    render_with_template(
      template: 'maglev/uikit/image_library/card_component_preview/default', 
      locals: { 
        image_url: '/images/img-3.jpg',
        filename: 'Image 3',
        width: 1920,
        height: 1920,
        byte_size: 217021
      }
    )
  end
  
  # @!endgroup

  private

  def asset
    Maglev::Asset.new(filename: 'test.jpg', content_type: 'image/jpeg', width: 100, height: 100, byte_size: 100)
  end
end