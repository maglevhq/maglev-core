# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Theme::LayoutGroup < Maglev::Theme::BaseProperty
  ## attributes ##
  attr_accessor :store, :accept, :recoverable

  validates :id, :label, 'maglev/presence': true

  ## instance methods ##

  # TODO: will be deprecated since we rely on page_store?
  def store?
    store.present? || store != false
  end

  def page_store?
    store == 'page' || store == false # TODO: store == false will be deprecated
  end

  def guess_store_handle(page)
    page_store? ? "#{id}-#{page.id}" : store
  end

  ## class methods ##

  def self.build(hash)
    attributes = prepare_attributes(hash).slice('id', 'label', 'store', 'accept', 'recoverable')

    attributes['accept'] ||= ['*']
    attributes['recoverable'] ||= []
    attributes['store'] = attributes['id'] if attributes['store'] != false && attributes['store'].blank?

    new(attributes)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
