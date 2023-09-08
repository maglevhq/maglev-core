# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Theme::StyleSetting
  ## concerns ##
  include ActiveModel::Model

  ## attributes ##
  attr_accessor :id, :label, :type, :default, :options

  ## validations ##
  validates :id, :label, :type, :default, 'maglev/presence': true
  validates :type, inclusion: { in: %w[text color select checkbox divider hint] }

  ## methods ##

  # NOTE: any modification to that method must be reflected to the JS editor
  def build_default_content(custom_default = nil)
    default = custom_default || self.default
    case type.to_sym
    when :checkbox then build_default_checkbox_content(default)
    else
      default || label
    end
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
