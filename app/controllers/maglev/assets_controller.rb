# frozen_string_literal: true

module Maglev
  class AssetsController < ApplicationController
    include Maglev::SiteConcern

    before_action :fetch_site, :fetch_asset

    def show
      send_data @asset.download, filename: @asset.filename, type: @asset.content_type
    end

    private

    def fetch_asset
      @asset = Maglev::Asset.find(params[:id])
    end
  end
end
