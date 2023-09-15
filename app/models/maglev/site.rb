# frozen_string_literal: true

module Maglev
  class Site < ApplicationRecord
    ## concerns ##
    include Maglev::Site::LocalesConcern
    include Maglev::SectionsConcern
    include Maglev::Translatable

    ## translations ##
    translates :sections

    ## validations ##
    validates :name, presence: true

    ## methods ##
    def api_attributes
      %i[id name]
    end

    def find_section(type)
      sections&.find { |section| section['type'] == type }
    end

    def translate_in(locale, source_locale)
      translate_attr_in(:sections, locale, source_locale)
    end
  end
end
