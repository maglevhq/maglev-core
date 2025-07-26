class ComponentPreviewController < ApplicationController
  include ViewComponent::PreviewActions

  before_action :set_locale

  private

  def set_locale
    I18n.locale = params.dig(:lookbook, :display, :lang)
  end
end
