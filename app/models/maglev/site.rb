# frozen_string_literal: true

module Maglev
  class Site < ApplicationRecord
    ## concerns ##
    include Maglev::Site::LocalesConcern
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

    def add_section(section)
      self.sections ||= []
      self.sections.delete_if { |site_section| site_section['type'] == section['type'] }      
      self.sections.push(section)
    end
  end
end
