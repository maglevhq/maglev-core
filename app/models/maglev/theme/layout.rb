# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Theme::Layout < Maglev::Theme::BaseProperty
  ## attributes ##
  attr_accessor :groups

  validates :id, :label, 'maglev/presence': true

  def find_group(group_id)
    groups.find { |group| group.id == group_id }
  end

  def page_scoped_stores
    groups.select { |group| group.page_scoped? }
  end

  ## class methods ##  

  def self.build(hash)
    attributes = prepare_attributes(hash).slice('id', 'label', 'groups')

    attributes['groups'] = Maglev::Theme::LayoutGroup.build_many(attributes['groups'])

    new(attributes)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
