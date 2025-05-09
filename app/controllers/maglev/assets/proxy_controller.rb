# frozen_string_literal: true

module Maglev
  module Assets
    class ProxyController < ApplicationController
      def show
        @asset = Maglev::Asset.find(resource_id)
        send_data @asset.download, filename: @asset.filename, type: @asset.content_type
        response.headers['Cache-Control'] = cache_control_header
      end

      private

      def cache_control_header
        # Rails 8+ uses :'cache-control' and Rails 7.x uses :'Cache-Control'
        Rails.configuration.public_file_server.headers[:'cache-control'] ||
          Rails.configuration.public_file_server.headers[:'Cache-Control']
      end
    end
  end
end
