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
end
