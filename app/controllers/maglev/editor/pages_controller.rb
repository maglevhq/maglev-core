class Maglev::Editor::PagesController < Maglev::Editor::BaseController
  def index
    @pages = Maglev::Page.all
  end
end