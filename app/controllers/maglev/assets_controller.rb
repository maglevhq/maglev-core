# frozen_string_literal: true

module Maglev
  class AssetsController < ApplicationController
    def show
      @asset = Maglev::Asset.find(resource_id)
      send_data @asset.download, filename: @asset.filename, type: @asset.content_type
    end
  end
end
