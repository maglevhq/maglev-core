# frozen_string_literal: true

module Maglev
  class AppContainer
    include Injectable

    dependency :config do
      Maglev.config
    end

    # hold the Rails request context
    dependency :context

    dependency :fetch_site,                 class: Maglev::FetchSite, depends_on: %i[config context]
    dependency :fetch_theme,                class: Maglev::FetchTheme, depends_on: %i[fetch_site context]
    dependency :fetch_theme_layout,         class: Maglev::FetchThemeLayout, depends_on: %i[fetch_theme]
    dependency :fetch_style,                class: Maglev::FetchStyle
    dependency :fetch_sections_path,        class: Maglev::FetchSectionsPath, depends_on: :fetch_theme
    dependency :fetch_section_screenshot_path, class: Maglev::FetchSectionScreenshotPath,
                                               depends_on: :fetch_sections_path
    dependency :fetch_section_screenshot_url, class: Maglev::FetchSectionScreenshotUrl,
                                              depends_on: :fetch_section_screenshot_path

    dependency :fetch_collection_items, class: Maglev::FetchCollectionItems, depends_on: %i[fetch_site config]
    dependency :fetch_static_pages, class: Maglev::FetchStaticPages, depends_on: %i[config]
    dependency :search_pages, class: Maglev::SearchPages, depends_on: %i[fetch_site fetch_static_pages context]

    dependency :get_base_url,               class: Maglev::GetBaseUrl, depends_on: %i[context fetch_site]
    dependency :extract_locale,             class: Maglev::ExtractLocale

    dependency :persist_section_screenshot, class: Maglev::PersistSectionScreenshot,
                                            depends_on: %i[fetch_theme fetch_section_screenshot_path]

    dependency :add_site_locale,            class: Maglev::AddSiteLocale
    dependency :change_site_locales,        class: Maglev::ChangeSiteLocales

    dependency :fetch_page,                 class: Maglev::FetchPage, depends_on: %i[context fetch_site]
    dependency :get_page_fullpath,          class: Maglev::GetPageFullpath, depends_on: %i[fetch_site get_base_url]
    dependency :get_page_sections,          class: Maglev::GetPageSections,
                                            depends_on: %i[fetch_site fetch_theme
                                                           fetch_static_pages
                                                           fetch_collection_items get_page_fullpath]
    dependency :get_page_section_names,     class: Maglev::GetPageSectionNames, depends_on: :fetch_theme
    dependency :clone_page,                 class: Maglev::ClonePage, depends_on: :fetch_site
    dependency :persist_page,               class: Maglev::PersistPage, depends_on: %i[fetch_theme]

    def call
      self
    end
  end
end
