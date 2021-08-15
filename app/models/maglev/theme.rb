# frozen_string_literal: true

module Maglev
  class Theme
    ## concerns ##
    include ActiveModel::Model

    ## attributes ##
    attr_accessor :id, :name, :description, :section_categories, :sections, :pages

    ## validations ##
    validates :id, :name, presence: true

    ## methods ##
  end
end
