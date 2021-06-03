# frozen_string_literal: true

module Maglev
  class AppContainer
    include Injectable

    dependency :config do
      Maglev.config
    end

    dependency :controller

    dependency :fetch_site,                 class: Maglev::FetchSite, depends_on: %i[config controller]
    dependency :fetch_theme,                class: Maglev::FetchTheme, depends_on: :fetch_site

    dependency :get_model_scopes,           class: Maglev::GetModelScopes
    dependency :get_base_url,               class: Maglev::GetBaseUrl, depends_on: %i[controller fetch_site]

    dependency :persist_section_screenshot, class: Maglev::PersistSectionScreenshot

    dependency :fetch_page,                 class: Maglev::FetchPage, depends_on: :fetch_site
    dependency :get_page_fullpath,          class: Maglev::GetPageFullpath, depends_on: %i[fetch_site get_base_url]
    dependency :get_page_sections,          class: Maglev::GetPageSections,
                                   depends_on: %i[fetch_site fetch_theme get_page_fullpath]
    dependency :get_page_section_names,     class: Maglev::GetPageSectionNames, depends_on: :fetch_theme
    dependency :persist_page,               class: Maglev::PersistPage, depends_on: %i[fetch_site fetch_theme]
    dependency :clone_page,                 class: Maglev::ClonePage, depends_on: :fetch_site
    dependency :setup_pages,                class: Maglev::SetupPages

    dependency :generate_site,              class: Maglev::GenerateSite, depends_on: %i[fetch_theme setup_pages]

    def call
      self
    end
  end
end
