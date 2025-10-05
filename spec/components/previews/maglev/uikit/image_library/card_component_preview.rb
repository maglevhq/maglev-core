# frozen_string_literal: true

module Maglev
  module Uikit
    module ImageLibrary
      class CardComponentPreview < ViewComponent::Preview
        # @!group Variants
        def default
          render_with_template(locals: { image: build_image(1) })
        end

        def with_vertical_image
          render_with_template(
            template: 'maglev/uikit/image_library/card_component_preview/default',
            locals: { image: build_image(2) }
          )
        end

        def with_square_image
          render_with_template(
            template: 'maglev/uikit/image_library/card_component_preview/default',
            locals: { image: build_image(3) }
          )
        end

        def with_very_long_filename
          image = build_image(3)
          render_with_template(
            template: 'maglev/uikit/image_library/card_component_preview/default',
            # rubocop:disable Layout/LineLength
            locals: { image: image.merge(filename: 'amory-timeo-manon-aram-et-sabrina-cinq-des-sept-animateurs-de-la-tabactiere-heureux-pour-le-gain-de-leur-client-photo-christian-salisson-1727456837.jpg') }
            # rubocop:enable Layout/LineLength
          )
        end

        # @!endgroup

        private

        def build_image(id)
          {
            id: id,
            image_url: "/images/img-#{id}.jpg",
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
