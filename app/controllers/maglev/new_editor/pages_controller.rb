class Maglev::NewEditor::PagesController < Maglev::NewEditor::BaseController
  def index
    @pages = Maglev::Page.all
  end
end