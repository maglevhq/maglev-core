# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Section::Setting
  ## concerns ##
  include ActiveModel::Model

  ## constants ##
  REGISTERED_TYPES = %w[text image checkbox link color select collection_item icon divider hint].freeze

  ## attributes ##
  attr_accessor :id, :label, :type, :default, :options

  ## validations ##
  validates :id, :label, :type, 'maglev/presence': true
  validates :type, inclusion: { in: REGISTERED_TYPES }

  ## methods ##

  # shortcuts
  REGISTERED_TYPES.each do |type|
    define_method(:"#{type}_type?") do
      self.type.to_s == type
    end
  end

  def cast_value(value)
    self.class.registered_types[type.to_s].cast_value(value)
  end

  # NOTE: any modification to that method must be reflected in the JS editor
  def build_default_content(custom_default = nil)
    default = custom_default.nil? ? self.default : custom_default

    # special case: text type
    default ||= label if text_type?

    cast_value(default)
  end

  ## class methods ##
  def self.build(hash)
    attributes = hash.slice('id', 'label', 'type', 'default')
    options = hash.except('id', 'label', 'type', 'default')

    new(attributes.merge(options: options))
  end

  def self.build_many(list)
    list.map { |hash| build(hash) }
  end

  def self.registered_types
    @registered_types ||= REGISTERED_TYPES.index_with do |type|
      "Maglev::SettingTypes::#{type.camelize}".constantize.new
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
