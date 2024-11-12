# frozen_string_literal: true

require 'forwardable'

module Maglev
  class SettingTypeRegistry
    CORE_TYPES = %w[text image checkbox link color select collection_item icon divider hint].freeze

    class << self
      extend Forwardable
      def_delegators :@instance, :types, :register, :[]
    end

    def initialize
      @setting_types = {}
    end

    def types
      @setting_types.keys
    end

    def register(id:, klass: nil)
      klass ||= "Maglev::SettingTypes::#{id.to_s.camelize}".constantize
      @setting_types[id.to_sym] = klass.new
    end

    def [](type)
      @setting_types[type.to_sym].tap do |setting|
        raise UnknownSettingTypeError, "Unknown #{type} setting type" if setting.nil?
      end
    end

    # register once all the core setting types
    @instance = new.tap do |registry|
      CORE_TYPES.each do |id|
        registry.register(id:)
      end
    end
  end

  class UnknownSettingTypeError < StandardError; end
end
