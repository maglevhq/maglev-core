class Maglev::Editor::PageCloneController < Maglev::Editor::BaseController
  def create
    @page = clone_page(resources.find(params[:page_id]))
    redirect_to edit_editor_page_path(@page, maglev_editing_route_context(page: @page)), notice: flash_t(:success), status: :see_other
  end

  private

  def clone_page(page)
    services.clone_page.call(page: page)
  end

  def resources
    ::Maglev::Page
  end
end