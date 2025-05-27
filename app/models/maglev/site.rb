# frozen_string_literal: true

# == Schema Information
#
# Table name: maglev_sites
#
#  id                    :bigint           not null, primary key
#  locales               :jsonb
#  lock_version          :integer
#  name                  :string
#  sections_translations :jsonb
#  style                 :jsonb
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
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
