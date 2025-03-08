# frozen_string_literal: true

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

# == Schema Information
#
# Table name: maglev_section_content_stores
#
#  id                    :bigint           not null, primary key
#  handle                :string           not null
#  sections_translations :jsonb
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
