# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from Maglev::Errors::NotAuthorized, with: :unauthorized_maglev

  private

  def current_account
    Account.first
  end

  protected

  def exotic_locale
    'fr'
  end

  def unauthorized_maglev
    flash[:error] = "You're not authorized to access the Maglev editor!"
    redirect_to main_app.nocoffee_path
  end
end
