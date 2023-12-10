# frozen_string_literal: true

module Maglev
  module Api
    class AssetsController < ::Maglev::ApiController
      include ::ActiveStorage::SetCurrent

      def index
        @assets = resources.search(
          params[:query], params[:asset_type], params[:page], params[:per_page]
        )
      end

      def show
        @asset = resources.find(resource_id)
      end

      def create
        asset = resources.create!(asset_params)
        head :created, location: api_asset_path(asset), maglev_asset_id: asset.id
      end

      def update
        resources.find(resource_id).update!(asset_params)
        head :ok
      end

      def destroy
        resources.find(resource_id).destroy!
        head :no_content
      end

      private

      def asset_params
        params.require(:asset).permit(:file)
      end

      def resources
        ::Maglev::Asset
      end
    end
  end
end
