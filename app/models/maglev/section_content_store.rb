module Maglev
  class SectionContentStore < ApplicationRecord
    ## concerns ##
    include Maglev::Translatable
    include Maglev::SectionsConcern
    
    ## translations ##
    translates :sections

    validates :handle, presence: true, uniqueness: true

    def find_section(type)
      sections&.find { |section| section['type'] == type }
    end
  end
end
