# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::Site::LocalesConcern
  extend ActiveSupport::Concern

  included do
    ## serializers ##
    if Rails::VERSION::MAJOR >= 8 || (Rails::VERSION::MAJOR >= 7 && Rails::VERSION::MINOR.positive?)
      serialize :locales, coder: LocalesSerializer
    else
      serialize :locales, LocalesSerializer
    end

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

  class LocalesSerializer
    def self.dump(array)
      (array || []).map(&:as_json)
    end

    def self.load(array)
      (array || []).map { |attributes| Maglev::Site::Locale.new(**attributes.symbolize_keys) }
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
