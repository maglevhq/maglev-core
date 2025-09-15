class Maglev::Editor::StyleController < Maglev::Editor::BaseController
  before_action :set_style

  def edit
  end

  def update
    maglev_services.persist_style.call(new_style: style_params)

    redirect_to edit_editor_style_path(maglev_editing_route_context), 
                  notice: flash_t(:success),
                  status: :see_other
  end

  private

  def set_style
    @style = maglev_services.fetch_style.call
  end

  def style_params
    params.require(:style).permit!
  end
end