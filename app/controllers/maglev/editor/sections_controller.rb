class Maglev::Editor::SectionsController < Maglev::Editor::BaseController
  def index
    @sections = services.get_page_sections.call(page: current_maglev_page)
  end
end
