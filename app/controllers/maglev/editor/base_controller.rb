class Maglev::Editor::BaseController < ApplicationController
  layout 'maglev/editor/application'

  include Maglev::ServicesConcern

  helper Maglev::ApplicationHelper

  before_action :set_locale
  before_action :fetch_page

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def fetch_page
    @page ||= Maglev::Page.find_by(id: params[:page_id])
  end
end