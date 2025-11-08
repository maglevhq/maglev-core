# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::Site::LocalesConcern
  extend ActiveSupport::Concern

  included do
    ## custom column type ##
    attribute :locales, :maglev_locales

    ## validation ##
    validates :locales, 'maglev/collection': true, length: { minimum: 1 }
  end

  def add_locale(locale)
    return nil if locale_prefixes.include?(locale.prefix.to_sym)

    locales << locale
    locales
  end

  def default_locale
    locales.first
  end

  def default_locale_prefix
    default_locale.prefix.to_sym
  end

  def locale_prefixes
    locales.map { |locale| locale.prefix.to_sym }
  end

  def each_locale
    locale_prefixes.each do |locale|
      Maglev::I18n.with_locale(locale) do
        yield(locale)
      end
    end
  end

  def many_locales?
    locales.size > 1
  end
end
# rubocop:enable Style/ClassAndModuleChildren
