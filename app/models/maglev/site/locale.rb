# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::Site::Locale
  ## concerns ##
  include ActiveModel::Model

  ## attributes ##
  attr_accessor :label, :prefix

  ## validations ##
  validates :label, :prefix, 'maglev/presence': true

  ## methods ##
  def as_json(_options = nil)
    { label: label, prefix: prefix }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
