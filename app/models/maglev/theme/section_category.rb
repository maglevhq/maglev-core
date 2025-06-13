# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Theme::SectionCategory < Maglev::Theme::BaseProperty
  ## class methods ##

  def self.build(hash)
    # keep compatibility with the previous versions of Maglev
    hash['label'] = hash['name'] if hash.respond_to?(:keys)

    new(prepare_attributes(hash).slice('id', 'label'))
  end
end
# rubocop:enable Style/ClassAndModuleChildren
