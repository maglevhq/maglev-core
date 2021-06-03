# frozen_string_literal: true

module Maglev
  class Site < ApplicationRecord
    ## validations ##
    validates :name, presence: true

    ## methods ##
    def find_section(type)
      sections.find { |section| section['type'] == type }
    end

    def add_section(section)
      sections.delete_if { |site_section| site_section['type'] == section['type'] }
      sections.push(section)
    end
  end
end
