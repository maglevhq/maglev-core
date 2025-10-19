# frozen_string_literal: true

module Maglev
  class CreatePageService
    include Injectable

    dependency :fetch_site

    argument :attributes
    argument :site, default: nil

    def call
      page = translate(build_page)
      page.save
      page
    end

    private

    def site
      @site ||= fetch_site.call
    end

    def build_page
      Maglev::Page.new(attributes)
    end

    def translate(page)
      site.locale_prefixes.each do |locale|
        Maglev::I18n.with_locale(locale) do
          # the title mightn't be empty if we set the title_translations field in "attributes"
          page.title ||= attributes[:title]
          page.path ||= attributes[:path]
        end
      end
      page
    end
  end
end
