# frozen_string_literal: true

module Maglev
  module Content
    class Image < Base
      def url
        return image[:url] if asset_host.nil? || !uploaded?
        URI::join(asset_host, URI::parse(image[:url]).path).to_s
      end

      def width
        image[:width]
      end

      def height
        image[:height]
      end

      def alt_text
        image[:alt_text]
      end

      def to_s
        url
      end

      def tag(view_context, options = {})
        view_context.tag(:img,
                         {
                           src: url,
                           alt: alt_text,
                           data: (options.delete(:data) || {}).merge(tag_data)
                         }.merge(options),
                         false)
      end

      private

      def image
        @image ||= if @content.is_a?(String)
                     { url: @content }
                   elsif @content
                     @content
                   else
                     {}
                   end
      end

      def uploaded?
        width.present? && height.present?
      end
    end
  end
end
