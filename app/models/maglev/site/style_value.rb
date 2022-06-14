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

    def method_missing(method_name, *_args)
      setting = array.find { |local_setting| local_setting.id == method_name.to_s }
      if setting
        setting.value
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      Rails.logger.debug 'yeasss!!!'
      array.map(&:id).include?(method_name.to_s) || super
    end

    def as_json(**_options)
      @array.as_json
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
