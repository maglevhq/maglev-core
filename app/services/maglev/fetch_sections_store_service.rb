# frozen_string_literal: true

module Maglev
  class FetchSectionsStoreService
    include Injectable

    dependency :fetch_theme
    dependency :fetch_site

    argument :page
    argument :handle
    argument :theme, default: nil
    argument :site, default: nil

    def call
      find_or_create_store(
        find_store_definition
      )
    end

    private

    def theme
      @theme ||= fetch_theme.call
    end

    def site
      @site ||= fetch_site.call
    end

    def find_or_create_store(store_definition)
      store_page = store_definition.page_scoped? ? page : nil

      scoped_stores.find_or_create_by(handle: store_definition.id, page: store_page, published: false) do |store|
        store.page = page if store_definition.page_scoped?
        store.sections_translations = fill_translations([])
      end
    end

    def find_store_definition
      find_layout.find_group(handle)
    end

    def find_layout
      theme.find_layout(page.layout_id).tap do |layout|
        if layout.nil?
          raise Maglev::Errors::MissingLayout,
                "#{layout_id} layout doesn't exist in the theme."
        end
      end
    end

    def fill_translations(value)
      site.locale_prefixes.index_with { |_locale| value }
    end

    def scoped_stores
      Maglev::SectionsContentStore
    end
  end
end
