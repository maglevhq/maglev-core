class Maglev::Editor::AssetsController < Maglev::Editor::BaseController
  include ::ActiveStorage::SetCurrent
  include ::Pagy::Backend

  before_action :ensure_turbo_frame_request, only: [:index]

  layout false

  def index
    @pagy, @assets = pagy(resources.search(params[:query], params[:asset_type]), limit: per_page)
  end

  def create
    asset = resources.create!(asset_params)
    flash[:notice] = flash_t(:success, count: params[:number_of_assets].presence || 1)
    head :created, location: editor_assets_path
  end

  def destroy
    asset = resources.find(resource_id)
    asset.destroy!
    redirect_to editor_assets_path(query: params[:query], page: params[:page]), notice: flash_t(:success, name: asset.file.filename), status: :see_other
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
end