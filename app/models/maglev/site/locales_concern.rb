# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::Site::LocalesConcern
  
  extend ActiveSupport::Concern

  included do
    ## serializers ##
    serialize :locales, LocalesSerializer

    ## validation ##
    validates :locales, 'maglev/collection': true, length: { minimum: 1 }
  end

  def default_locale
    locales.first
  end

  def locale_prefixes
    locales.map { |locale| locale.prefix.to_sym }
  end

  class LocalesSerializer
    def self.dump(array)
      (array || []).map { |locale| locale.as_json }
    end

    def self.load(array)
      (array || []).map { |attributes| Maglev::Site::Locale.new(**attributes.symbolize_keys) }
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
