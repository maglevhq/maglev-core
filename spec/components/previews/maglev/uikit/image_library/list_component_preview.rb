# frozen_string_literal: true

module Maglev
  module Uikit
    module ImageLibrary
      class ListComponentPreview < ViewComponent::Preview
        def default
          render(Maglev::Uikit::ImageLibrary::ListComponent.new) do |component|
            images.each do |image|
              component.with_image(**image)
            end
          end
        end

        private

        def images
          16.times.map do |i|
            {
              id: i,
              image_url: '/images/img-1.jpg',
              filename: 'Image 1',
              width: 1920,
              height: 1080,
              byte_size: 217_021,
              delete_path: '#'
            }
          end
        end
      end
    end
  end
end
