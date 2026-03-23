# frozen_string_literal: true

module Maglev
  module ActiveStorage
    # Since assets are uploaed by editors, we can assume they are always safe to serve.
    # Wraps ActiveStorage::Blob only for Maglev's proxy: Active Storage maps image/svg+xml to
    # application/octet-stream globally; we serve SVG as image/svg+xml without changing the host app's config.
    class ServingBlob < SimpleDelegator
      def content_type_for_serving
        return 'image/svg+xml' if svg?

        __getobj__.content_type_for_serving
      end

      def forced_disposition_for_serving
        return nil if svg?

        __getobj__.forced_disposition_for_serving
      end

      private

      def svg?
        filename.to_s.downcase.end_with?('.svg') ||
          content_type.to_s == 'image/svg+xml'
      end
    end
  end
end
