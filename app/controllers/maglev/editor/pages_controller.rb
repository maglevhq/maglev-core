class Maglev::Editor::PagesController < Maglev::Editor::BaseController
  def index
    logger.info "turbo_frame_request? #{turbo_frame_request?} 🤔🤔🤔"
    @pages = Maglev::Page.all
    render layout: false if turbo_frame_request?
  end
end