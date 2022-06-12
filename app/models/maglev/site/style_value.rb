# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Site::StyleValue
  
  ## attributes ##
  attr_accessor :id, :value, :type

  def initialize(id, type, value)
    @id = id
    @type = type
    @value = value
  end

  class Store
    extend Forwardable
    def_delegators :@array, :all, :first, :last, :count, :each, :each_with_index, :map, :group_by

    attr_reader :array

    def initialize(array)
      @array = array
    end

    def method_missing(method_name, *args)
      setting = array.find { |setting| setting.id == method_name.to_s }
      raise "Unknown style '#{method_name}'" if !setting
      setting.value
    end

    def as_json(**_options)
      @array.as_json
    end
  end
end