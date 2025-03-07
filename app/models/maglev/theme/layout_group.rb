# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Theme::LayoutGroup < Maglev::Theme::BaseProperty
  ## attributes ##
  attr_accessor :store, :accept

  validates :id, :label, 'maglev/presence': true

  ## instance methods ##

  def store?
    store.present? || store != false
  end

  ## class methods ##

  def self.build(hash)
    attributes = prepare_attributes(hash).slice('id', 'label', 'store', 'accept')

    attributes['accept'] ||= []
    attributes['store'] ||= attributes['id']

    new(attributes)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
