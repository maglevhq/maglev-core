# frozen_string_literal: true

module Maglev
  # Clone a page in all the locales.
  # The service also makes sure that
  # the path of the cloned page will be unique.
  class ClonePage
    include Injectable

    argument :page

    def call
      return nil unless page.persisted?

      create_page!
    end

    protected

    def create_page!
      Maglev::Page.new(cloned_attributes).tap do |cloned_page|
        cloned_page.disable_spawn_redirection
        clone_paths(cloned_page)
        cloned_page.save!
      end
    end

    private

    def cloned_attributes
      {
        title_translations: clone_title,
        seo_title_translations: page.seo_title_translations,
        meta_description_translations: page.meta_description_translations,
        og_title_translations: page.og_title_translations,
        og_description_translations: page.og_description_translations,
        og_image_url_translations: page.og_image_url_translations,
        sections_translations: page.sections_translations
      }
    end

    def clone_title
      page.title_translations.transform_values do |title|
        ::I18n.t('activerecord.attributes.maglev/page.cloned_title', title: title)
      end
    end

    def clone_paths(cloned_page)
      code = generate_clone_code(4)
      page.path_hash.each do |locale, path|
        Maglev::I18n.with_locale(locale) do
          cloned_page.path = "#{path}-#{code}"
        end
      end
    end

    def generate_clone_code(number)
      charset = Array('A'..'Z') + Array('a'..'z')
      Array.new(number) { charset.sample }.join
    end
  end
end
