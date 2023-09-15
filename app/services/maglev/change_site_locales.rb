# frozen_string_literal: true

module Maglev
  # Change the locales of a site.
  # The new locales are an array of Maglev::Site::Locale objects
  class ChangeSiteLocales
    include Injectable

    argument :site
    argument :locales

    def call
      return if locales.blank?

      if default_locale_changed? && !all_paths_translated?
        raise 'The translations for the new default locale are incomplete'
      end

      site.update(locales: locales)
    end

    protected

    def new_default_locale_prefix
      locales.first.prefix.to_sym
    end

    def default_locale_changed?
      new_default_locale_prefix != site.default_locale_prefix
    end

    def all_paths_translated?
      Maglev::PagePath.where(locale: site.default_locale_prefix).count ==
        Maglev::PagePath.where(locale: new_default_locale_prefix).count
    end
  end
end
