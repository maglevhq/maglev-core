module Maglev
  class LocalesType < ActiveRecord::Type::Json
    attr_reader :adapter_name

    def initialize(adapter_name:)
      @adapter_name = adapter_name
    end

    def deserialize(value)
      (super || []).map { |attributes| Maglev::Site::Locale.new(**attributes.symbolize_keys) }
    end

    private

    def mysql?
      adapter_name.downcase == 'mysql2'
    end
  end
end