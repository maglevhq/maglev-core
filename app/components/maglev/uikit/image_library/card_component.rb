# frozen_string_literal: true

module Maglev
  module Uikit
    module ImageLibrary
      class CardComponent < Maglev::Uikit::BaseComponent
        attr_reader :id, :image_url, :filename, :width, :height, :byte_size, :delete_path, :picker_attributes

        def initialize(image:, delete_path:, picker_attributes: nil)
          @id = image[:id]
          @image_url = image[:image_url]
          @filename = image[:filename]
          @width = image[:width]
          @height = image[:height]
          @byte_size = image[:byte_size]
          @delete_path = delete_path
          @picker_attributes = picker_attributes
        end

        def picker_mode?
          picker_attributes.present? && picker_attributes[:picker].present?
        end

        def picker_event_payload
          {
            source: picker_attributes[:source],
            image: picker_event_image_payload
          }.to_json
        end

        def picker_event_image_payload
          {
            id: id,
            filename: filename,
            url: image_url,
            width: width,
            height: height,
            byte_size: byte_size
          }
        end

        def picker_event_name
          "image-selected-#{picker_attributes[:source]}"
        end

        def width_and_height?
          width.present? && height.present?
        end
      end
    end
  end
end
