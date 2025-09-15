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

  class AssociationProxy
    include Enumerable

    attr_reader :style_values

    def initialize(values)
      @style_values = values
    end

    def [](id)
      style_values.find { |setting| setting.id == id }
    end

    def each(&block)
      style_values.each(&block)
    end

    def value_of(id)
      self[id]&.value
    end

    def method_missing(method_name, *_args)
      setting = self[method_name.to_s]
      if setting
        setting.value
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      style_values.map(&:id).include?(method_name.to_s) || super
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
