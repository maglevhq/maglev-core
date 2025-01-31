module Maglev
  class SectionRepository < ApplicationRecord
    ## concerns ##
    include Maglev::Translatable
    include Maglev::SectionsConcern

    ## translations ##
    translates :sections

    ## validations ##
    validates :name, presence: true
  end
end