# frozen_string_literal: true

module Maglev
  class AssetsController < ApplicationController
    def show
      @asset = model_scopes(:asset).find(params[:id])
      send_data @asset.download, filename: @asset.filename, type: @asset.content_type
    end
  end
end
