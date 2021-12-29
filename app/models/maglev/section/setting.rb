# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Section::Setting
  DEFAULT_TYPES = %w[text image checkbox link color select collection_item icon].freeze

  ## concerns ##
  include ActiveModel::Model

  ## attributes ##
  attr_accessor :id, :label, :type, :default, :options

  ## validations ##
  validates :id, :label, :type, :default, 'maglev/presence': true
  validates :type, inclusion: { in: DEFAULT_TYPES + Maglev.config.custom_setting_types }

  ## methods ##

  # NOTE: any modification to that method must be reflected to the JS editor
  def build_default_content(custom_default = nil)
    default = custom_default || self.default

    default_method_name = :"build_default_#{type}_content"

    if respond_to?(default_method_name)
      public_send(default_method_name, default)
    else
      default || label
    end
  end

  def build_default_image_content(default)
    default.is_a?(String) ? { url: default } : {}
  end

  def build_default_link_content(default)
    default.is_a?(String) ? { link_type: 'url', href: default } : { link_type: 'url', href: '#' }.merge(default)
  end

  def build_default_checkbox_content(default)
    !default.nil?
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
end
# rubocop:enable Style/ClassAndModuleChildren
