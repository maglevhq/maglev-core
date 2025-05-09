# frozen_string_literal: true

module Maglev
  module Assets
    class ProxyController < ApplicationController
      def show
        @asset = Maglev::Asset.find(resource_id)
        send_data @asset.download, filename: @asset.filename, type: @asset.content_type
        response.headers['Cache-Control'] = Rails.configuration.public_file_server.headers[:'cache-control']
      end
    end
  end
end
