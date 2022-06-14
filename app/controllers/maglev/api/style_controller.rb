# frozen_string_literal: true

module Maglev
  module API
    class StyleController < ::Maglev::APIController
      def update
        @site = maglev_site
        @site.update(site_params)
        head :ok
      end

      private

      def site_params
        params.require(:site).permit.tap do |whitelisted|
          whitelisted[:style] = params[:site].to_unsafe_hash[:style] unless params.dig(:site, :style).nil?
        end
      end
    end
  end
end
