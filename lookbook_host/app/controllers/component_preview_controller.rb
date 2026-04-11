# frozen_string_literal: true

class ComponentPreviewController < ApplicationController
  include ViewComponent::PreviewActions
  include Maglev::ServicesConcern

  helper Maglev::ApplicationHelper

  before_action :set_locale

  private

  def set_locale
    I18n.locale = params.dig(:lookbook, :display, :lang)
  end
end
