# frozen_string_literal: true

module Maglev
  module Editor
    class AssetsController < Maglev::Editor::BaseController
      include ::ActiveStorage::SetCurrent
      include ::Pagy::Backend

      before_action :ensure_turbo_frame_request, only: [:index]

      helper_method :query_params

      layout false

      def index
        @pagy, @assets = pagy(resources.search(params[:query], params[:asset_type]), limit: per_page)
      end

      def create
        resources.create!(asset_params)
        flash[:notice] = flash_t(:success, count: params[:number_of_assets].presence || 1)
        head :created, location: editor_assets_path
      end

      def destroy
        asset = resources.find(resource_id)
        asset.destroy!
        redirect_to editor_assets_path(query_params(pagination: true)),
                    notice: flash_t(:success, name: asset.file.filename), status: :see_other
      end

      private

      def asset_params
        params.require(:asset).permit(:file)
      end

      def per_page
        16 # TODO: make this configurable
      end

      def resources
        ::Maglev::Asset
      end

      def assets_path_with_context
        editor_assets_path({
          picker: params[:picker],
          source: params[:source]
        }.compact_blank)
      end

      def query_params(pagination: false)
        base = { picker: params[:picker], source: params[:source] }
        (pagination ? base.merge(query: params[:query], page: params[:page]) : base).compact_blank
      end
    end
  end
end
