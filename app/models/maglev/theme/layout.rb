# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Theme::Layout < Maglev::Theme::BaseProperty
  ## attributes ##
  attr_accessor :theme, :groups

  validates :id, :label, 'maglev/presence': true

  def human_name
    ::I18n.t("maglev.themes.#{theme.id}.layouts.#{id}", default: label)
  end

  def find_group(group_id)
    groups.find { |group| group.id == group_id }
  end

  def page_scoped_stores
    groups.select(&:page_scoped?)
  end

  ## class methods ##

  def self.build(hash, **args)
    attributes = prepare_attributes(hash).slice('id', 'label')

    new(attributes.merge(theme: args[:theme])).tap do |layout|
      layout.groups = Maglev::Theme::LayoutGroup.build_many(
        hash['groups'] || [],
        theme: args[:theme],
        layout_id: layout.id
      )
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
