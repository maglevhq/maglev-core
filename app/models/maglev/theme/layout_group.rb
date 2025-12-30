# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Theme::LayoutGroup < Maglev::Theme::BaseProperty
  ## attributes ##
  attr_accessor :accept, :page_scoped, :recoverable, :mirror_section

  validates :id, :label, 'maglev/presence': true

  alias_attribute :handle, :id

  ## instance methods ##

  def page_scoped?
    !!page_scoped
  end

  def accepts?(section)
    check_against(accept, section)    
  end

  def recoverable?(section)
    section.singleton? && check_against(recoverable, section)
  end

  private

  def check_against(list, section)
    list.include?('*') || 
    list.include?(section.id) || 
    list.include?("#{section.category}/#{section.id}") || 
    list.include?("#{section.category}/*")
  end

  ## class methods ##

  def self.build(hash)
    attributes = prepare_attributes(hash).slice('id', 'label', 'page', 'accept', 'recoverable', 'mirror_section')

    attributes['accept'] ||= ['*']
    attributes['recoverable'] ||= []
    attributes['page_scoped'] = !!attributes.delete('page')
    
    new(attributes)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
