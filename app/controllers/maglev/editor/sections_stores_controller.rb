class Maglev::Editor::SectionsStoresController < Maglev::Editor::BaseController
  def index
    @sections_stores = current_maglev_page_content.stores
  end
end