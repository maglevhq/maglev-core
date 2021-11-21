# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def current_account
    Account.first
  end

  protected

  def exotic_locale
    'fr'
  end

  # def is_authenticated(maglev_site)
  #   true
  # end

  # def is_not_authenticated(maglev_site)
  #   false
  # end
end
