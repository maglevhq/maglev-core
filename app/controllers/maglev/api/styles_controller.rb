# frozen_string_literal: true

module Maglev
  module Api
    class StylesController < ::Maglev::ApiController
      def update
        @site = maglev_site
        @site.update(style: style_params)
        head :ok
      end

      private

      def style_params
        params.to_unsafe_hash[:style]
      end
    end
  end
end
