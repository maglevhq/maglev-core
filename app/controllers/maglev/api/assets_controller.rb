# frozen_string_literal: true

module Maglev
  module API
    class AssetsController < APIController
      include ::ActiveStorage::SetCurrent

      def index
        @assets = Maglev::Asset.search(
          params[:query], params[:asset_type], params[:page], params[:per_page]
        )
      end

      def show
        @asset = Maglev::Asset.find(params[:id])
      end

      def create
        asset = Maglev::Asset.create!(asset_params)
        head :created, location: api_asset_path(asset), maglev_asset_id: asset.id
      end

      def update
        Maglev::Asset.find(params[:id]).update!(asset_params)
        head :ok
      end

      def destroy
        Maglev::Asset.find(params[:id]).destroy!
        head :no_content
      end

      private

      def asset_params
        params.require(:asset).permit(:file)
      end
    end
  end
end
