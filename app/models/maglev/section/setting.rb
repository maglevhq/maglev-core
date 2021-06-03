# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Section::Setting
  ## concerns ##
  include ActiveModel::Model

  ## attributes ##
  attr_accessor :id, :label, :type, :default, :options

  ## validations ##
  validates :id, :label, :type, :default, 'maglev/presence': true
  validates :type, inclusion: { in: %w[text image_picker checkbox link] }

  ## methods ##

  def build_default_content
    case type.to_sym
    when :image_picker
      default.is_a?(String) ? { url: default } : {}
    when :link
      default.is_a?(String) ? { link_type: 'url', href: default } : {}
    else
      default || label
    end
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
