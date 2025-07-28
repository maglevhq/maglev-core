# frozen_string_literal: true

class Maglev::Uikit::AppLayoutComponent < ViewComponent::Base

  attr_reader :page

  def initialize(page:)
    @page = page
  end

  def editor_root_path
    helpers.maglev.editor_real_root_path(locale: I18n.locale, page_id: page.id)
  end

  def editor_pages_path
    helpers.maglev.editor_pages_path(locale: I18n.locale, page_id: page.id)
  end

  def editor_sections_path
    helpers.maglev.editor_sections_path(locale: I18n.locale, page_id: page.id)
  end
end
