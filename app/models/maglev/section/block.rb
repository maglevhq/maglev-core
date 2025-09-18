# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Section::Block
  ## concerns ##
  include ActiveModel::Model

  ## attributes ##
  attr_accessor :name, :type, :settings, :root, :accept, :limit, :section

  ## validation ##
  validates :name, :type, presence: true
  validates :settings, 'maglev/collection': true

  ## methods

  def human_name
    ::I18n.t("#{section.i18n_scope}.blocks.types.#{type}", default: name.humanize)
  end

  def root?
    !!root
  end

  def main_settings
    settings.reject(&:advanced?)
  end

  def advanced_settings
    settings.select(&:advanced?)
  end

  def as_json
    super(only: %i[name type settings root accept])
  end

  ## class methods ##

  def self.build(hash, section:)
    attributes = hash.slice('name', 'type', 'accept', 'root', 'limit')
    attributes['root'] = true if attributes['root'].nil?
    attributes['limit'] = -1 if attributes['limit'].nil?

    new(
      **attributes.merge(
        settings: Maglev::Section::Setting.build_many(hash['settings']),
        section: section
      )
    )
  end

  def self.build_many(list, section:)
    return [] if list.blank?

    list.map do |hash_or_object|
      hash_or_object.is_a?(Hash) ? build(hash_or_object, section: section) : hash_or_object
    end
  end

  class Store    
    include Enumerable

    attr_reader :array

    def initialize(blocks, section:)
      @array = ::Maglev::Section::Block.build_many(blocks, section: section)
    end

    def find(type)
      array.find { |block| block.type == type }
    end

    def each(&block)
      array.each(&block)
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
