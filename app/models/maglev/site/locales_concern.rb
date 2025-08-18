# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::Site::LocalesConcern
  extend ActiveSupport::Concern  

  included do 
    ## serializers ##
    # if Rails::VERSION::MAJOR >= 8 || (Rails::VERSION::MAJOR >= 7 && Rails::VERSION::MINOR.positive?)
    #   serialize :locales, coder: LocalesSerializer
    # else
    #   serialize :locales, LocalesSerializer
    # end

    ## custom column type ##
    attribute :locales, :maglev_locales, adapter_name: ActiveRecord::Base.connection.adapter_name

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
  
  # class LocalesType < ActiveRecord::Type::Json
  #   attr_reader :adapter_name

  #   def initialize(adapter_name:)
  #     @adapter_name = adapter_name
  #   end

  #   def deserialize(value)
  #     pp "deserialize #{value} 🍿 #{@adapter_name}"

  #     # in MariaDB, the array is a string, so we need to parse it first
  #     value = JSON.parse(value) if value.is_a?(String)

  #     (value || []).map { |attributes| Maglev::Site::Locale.new(**attributes.symbolize_keys) }
  #   end

  #   def serialize(value)
  #     pp "serialize #{value} 🍿"

  #     value = (value || []).map(&:as_json)

  #     # MariaDB doesn't support default values for json columns, so we need to convert it to a JSON string
  #     # MySQL is ok to also use a JSON string
  #     mysql? ? value.to_json : value
  #   end

  #   private

  #   def mysql?
  #     @adapter_name.downcase == 'mysql2'
  #   end
  # end

  # class LocalesSerializer
  #   def self.dump(array)
  #     pp "self.load #{array} 🍿"
  #     (array || []).map(&:as_json)

  #     # in MariaDB, the array is a string, so we need to convert it to a JSON string
  #     # (array || []).to_json
  #   end

  #   def self.load(array)
  #     pp "self.load #{array} 🥸"
  #     # in MariaDB, the array is a string, so we need to parse it
  #     array = JSON.parse(array) if array.is_a?(String)

  #     (array || []).map { |attributes| Maglev::Site::Locale.new(**attributes.symbolize_keys) }
  #   end
  # end
end
# rubocop:enable Style/ClassAndModuleChildren
