# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Section::Setting
  ## concerns ##
  include ActiveModel::Model

  ## attributes ##
  attr_accessor :id, :label, :type, :default, :options

  ## validations ##
  validates :id, :label, :type, :default, 'maglev/presence': true
  validates :type, inclusion: { in: -> { Maglev::SettingTypeRegistry.types.map(&:to_s) } }

  ## methods ##

  # NOTE: any modification to that method must be reflected in the JS editor
  def build_default_content(custom_default = nil)
    default = setting_type.default_for(
      label:,
      default: custom_default.nil? ? self.default : custom_default
    )

    cast_value(default)
  end

  delegate :cast_value, to: :setting_type

  delegate :content_class, to: :setting_type

  ## class methods ##

  def self.build(hash)
    attributes = hash.slice('id', 'label', 'type', 'default')
    options = hash.except('id', 'label', 'type', 'default')

    new(attributes.merge(options:))
  end

  def self.build_many(list)
    list.map { |hash| build(hash) }
  end

  private

  def setting_type
    Maglev::SettingTypeRegistry[type]
  end
end
# rubocop:enable Style/ClassAndModuleChildren
