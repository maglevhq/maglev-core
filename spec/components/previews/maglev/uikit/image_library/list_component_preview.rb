# frozen_string_literal: true

module Maglev
  module Uikit
    module ImageLibrary
      class ListComponentPreview < ViewComponent::Preview
        def default
          render(Maglev::Uikit::ImageLibrary::ListComponent.new) do |component|
            images.each do |image|
              component.with_image(image: image, delete_path: '#')
            end
          end
        end

        private

        def images
          16.times.map do |index|
            build_image(index)
          end
        end

        def build_image(id)
          {
            id: id,
            image_url: '/images/img-1.jpg',
            filename: "Image #{id}",
            width: 1920,
            height: 1080,
            byte_size: 217_021
          }
        end
      end
    end
  end
end
