# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Theme::LayoutGroup < Maglev::Theme::BaseProperty
  ## attributes ##
  attr_accessor :accept, :page_scoped, :recoverable, :mirror_section, :theme, :layout_id, :handle

  validates :id, :label, 'maglev/presence': true

  # alias_attribute :handle, :id

  ## instance methods ##

  def human_name
    ::I18n.t("maglev.themes.#{theme.id}.layouts.#{layout_id}.stores.#{id}", default: label)
  end

  def page_scoped?
    !!page_scoped
  end

  def mirror_section?
    mirror_section.nil? || !!mirror_section
  end

  def accepts?(section)
    check_against(accept, section)
  end

  def recoverable?(section)
    section.singleton? && check_against(recoverable, section)
  end

  ## class methods ##

  def self.build(hash, **args)
    attributes = prepare_attributes(hash).slice('id', 'handle', 'label', 'page', 'accept', 'recoverable',
                                                'mirror_section')

    prepare_other_attributes(attributes)

    new(attributes.merge(theme: args[:theme], layout_id: args[:layout_id]))
  end

  def self.prepare_other_attributes(attributes)
    attributes['handle'] = attributes['handle'].presence || attributes['id']
    attributes['accept'] ||= ['*']
    attributes['recoverable'] ||= []
    attributes['page_scoped'] = !attributes.delete('page').nil?
  end

  ## private methods ##

  private

  def check_against(list, section)
    list.include?('*') ||
      list.include?(section.id) ||
      list.include?("#{section.category}/#{section.id}") ||
      list.include?("#{section.category}/*")
  end
end
# rubocop:enable Style/ClassAndModuleChildren
