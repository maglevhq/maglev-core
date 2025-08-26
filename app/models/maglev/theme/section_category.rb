# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Theme::SectionCategory
  ## concerns ##
  include ActiveModel::Model

  ## attributes ##
  attr_accessor :name, :id, :theme

  ## methods ##
  def human_name
    I18n.t("maglev.themes.#{theme.id}.categories.#{id}.name", default: name.humanize)
  end

  ## class methods ##

  def self.build(hash)
    attributes = hash.slice('name', 'id')
    attributes['id'] ||= attributes['name'].parameterize(separator: '_')
    new(attributes)
  end

  def self.build_many(list)
    (list || []).map { |hash| build(hash) }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
