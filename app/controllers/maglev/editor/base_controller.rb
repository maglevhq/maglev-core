class Maglev::Editor::BaseController < ::Maglev::ApplicationController
  layout 'maglev/editor/application'

  include Maglev::UserInterfaceLocaleConcern
  include Maglev::ContentLocaleConcern
  include Maglev::ServicesConcern

  before_action :fetch_maglev_site
  before_action :fetch_page
  before_action :set_content_locale

  helper Maglev::ApplicationHelper
  helper_method :maglev_site, :maglev_theme
  
  private

  def fetch_maglev_site
    maglev_site # simply force the fetching of the current site
  end

  def maglev_site
    @maglev_site ||= services.fetch_site.call
  end

  def maglev_theme
    @maglev_theme ||= maglev_services.fetch_theme.call
  end

  def fetch_page
    @page ||= Maglev::Page.find_by(id: params[:page_id])
  end
end