# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def current_account
    Account.first
  end
end
