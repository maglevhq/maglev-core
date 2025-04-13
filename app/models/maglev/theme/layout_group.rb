# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Theme::LayoutGroup < Maglev::Theme::BaseProperty
  ## attributes ##
  attr_accessor :store, :accept, :recoverable, :mirror_section

  validates :id, :label, 'maglev/presence': true

  ## instance methods ##

  def page_store?
    store == 'page'
  end

  def guess_store_handle(page)
    page_store? ? "#{id}-#{page.id}" : store
  end

  ## class methods ##

  def self.build(hash)
    attributes = prepare_attributes(hash).slice('id', 'label', 'store', 'accept', 'recoverable', 'mirror_section')

    attributes['accept'] ||= ['*']
    attributes['recoverable'] ||= []
    attributes['store'] = attributes['id'] if attributes['store'] != false && attributes['store'].blank?

    new(attributes)
  end

  def self.default_group
    { id: 'main', label: 'Main' }.with_indifferent_access
  end
end
# rubocop:enable Style/ClassAndModuleChildren
