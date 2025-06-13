# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::FetchThemeConcern
  def theme
    @theme ||= fetch_theme.call
  end

  def layout
    theme.find_layout(page.layout_id).tap do |layout|
      raise Maglev::Errors::MissingLayout, "The page #{page.id} misses the layout_id property" if layout.nil?
    end
  end

  def layout_page_groups
    layout.groups.find_all(&:page_store?)
  end

  def sections_content_stores
    Maglev::SectionsContentStore
  end
end
# rubocop:enable Style/ClassAndModuleChildren
