# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Theme::BaseProperty
  ## concerns ##
  include ActiveModel::Model

  attr_accessor :id, :label, :theme

  ## class methods ##

  def self.build(_hash)
    raise 'TO BE IMPLEMENTED'
  end

  def self.build_many(list)
    (list || []).map { |hash| build(hash) }
  end

  def self.prepare_attributes(hash_or_string)
    # rubocop:disable Style/StringHashKeys
    hash = hash_or_string.is_a?(String) ? { 'label' => hash_or_string } : hash_or_string
    # rubocop:enable Style/StringHashKeys

    if hash['id'].present? || hash['label'].present?
      hash['label'] ||= hash['id'].humanize
      hash['id'] ||= hash['label'].parameterize(separator: '_')
    end

    hash
  end
end
# rubocop:enable Style/ClassAndModuleChildren
