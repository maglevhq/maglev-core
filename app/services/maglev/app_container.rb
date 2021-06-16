# frozen_string_literal: true

module Maglev
  class AppContainer
    include Injectable

    dependency :config do
      Maglev.config
    end

    dependency :context # hold the request context

    dependency :fetch_site,                 class: Maglev::FetchSite, depends_on: %i[config context]
    dependency :fetch_theme,                class: Maglev::FetchTheme, depends_on: %i[fetch_site context]
    dependency :fetch_theme_layout,         class: Maglev::FetchThemeLayout, depends_on: %i[fetch_theme]
    dependency :fetch_sections_path,        class: Maglev::FetchSectionsPath
    dependency :fetch_screenshot_path,      class: Maglev::FetchScreenshotPath, depends_on: :fetch_sections_path
    dependency :templates_root_path,        class: Maglev::TemplatesRootPath, depends_on: %i[fetch_sections_path]

    dependency :get_model_scopes,           class: Maglev::GetModelScopes
    dependency :get_base_url,               class: Maglev::GetBaseUrl, depends_on: %i[context fetch_site]

    dependency :persist_section_screenshot, class: Maglev::PersistSectionScreenshot, depends_on: %i[fetch_theme fetch_screenshot_path]

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