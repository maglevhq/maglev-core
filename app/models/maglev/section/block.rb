# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Section::Block
  ## concerns ##
  include ActiveModel::Model

  ## attributes ##
  attr_accessor :name, :type, :settings, :root, :accept, :limit

  ## validation ##
  validates :name, :type, presence: true
  validates :settings, 'maglev/collection': true

  ## methods

  def root?
    !!root
  end

  ## class methods ##

  def self.build(hash)
    attributes = hash.slice('name', 'type', 'accept', 'root', 'limit')
    attributes['root'] = true if attributes['root'].nil?
    attributes['limit'] = -1 if attributes['limit'].nil?

    new(
      attributes.merge(
        settings: Maglev::Section::Setting.build_many(hash['settings'])
      )
    )
  end

  def self.build_many(list)
    return [] if list.blank?

    list.map { |hash| build(hash) }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
