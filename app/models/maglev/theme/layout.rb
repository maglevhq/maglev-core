# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Theme::Layout < Maglev::Theme::BaseProperty
  ## attributes ##
  attr_accessor :groups

  validates :id, :label, 'maglev/presence': true

  ## class methods ##

  def self.build(hash)
    attributes = prepare_attributes(hash).slice('id', 'label', 'groups')

    attributes['groups'] = Maglev::Theme::LayoutGroup.build_many(attributes['groups'])

    new(attributes)
  end

  def self.build_many(list)
    super(list.presence || [default_layout])
  end

  def self.default_layout
    { id: 'default', label: 'Default', groups: [Maglev::Theme::LayoutGroup.default_group] }.with_indifferent_access
  end
end
# rubocop:enable Style/ClassAndModuleChildren
