class Maglev::Editor::PagesController < Maglev::Editor::BaseController
  def index
    @pages = Maglev::Page.all
  end

  def edit
    @page = services.search_pages.call(id: params[:id], content_locale: content_locale,
                                           default_locale: default_content_locale)
  end
end