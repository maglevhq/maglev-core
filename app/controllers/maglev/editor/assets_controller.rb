class Maglev::Editor::AssetsController < Maglev::Editor::BaseController
  include ::ActiveStorage::SetCurrent
  include ::Pagy::Backend

  layout false

  def index
    @pagy, @assets = pagy(resources.search(params[:query], params[:asset_type]), limit: per_page)
  end

  # def show
  #   @asset = resources.find(resource_id)
  # end

  def create
    asset = resources.create!(asset_params)
    head :created, location: api_asset_path(asset), maglev_asset_id: asset.id
  end

  # def update
  #   resources.find(resource_id).update!(asset_params)
  #   head :ok
  # end

  def destroy
    resources.find(resource_id).destroy!
    redirect_to editor_assets_path(query: params[:query], page: params[:page]), status: :see_other
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