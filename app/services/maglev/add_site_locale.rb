# frozen_string_literal: true

module Maglev
  # Add a locale (instace of Maglev::Site::Locale) to a site
  class AddSiteLocale
    include Injectable

    argument :site
    argument :locale

    def call
      return if locale.blank? || !site.add_locale(locale)

      ActiveRecord::Base.transaction do
        unsafe_call
      end
    end

    protected

    def unsafe_call
      # Set a default content for site_scoped sections
      apply_to_site

      site.save! # persist the new locale

      # add a default content in the new locale to all the pages of the site
      # based on the default locale. Also take care of the path.
      apply_to_pages

      true
    end

    def apply_to_site
      Maglev::I18n.with_locale(locale.prefix) do
        site.translate_in(locale.prefix, site.default_locale_prefix)
      end
    end

    def apply_to_pages
      resources.find_each do |page|
        # the path will be the same as in the default locale
        Maglev::I18n.with_locale(locale.prefix) do
          page.path = default_page_path(page)
        end

        # set a default content which will be the same as in the default locale
        page.translate_in(locale.prefix, site.default_locale_prefix)

        page.save!
      end
    end

    def default_page_path(page)
      # we can't rely on page.default_path because the service can be called outside a HTTP request
      # and so we don't know for sure if Maglev::I18n.default_locale has been correctly set.
      page.paths.find_by(locale: site.default_locale.prefix)&.value
    end

    def resources
      ::Maglev::Page
    end
  end
end
