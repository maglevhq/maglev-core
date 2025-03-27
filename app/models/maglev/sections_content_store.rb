# frozen_string_literal: true

module Maglev
  class SectionsContentStore < ApplicationRecord
    ## concerns ##
    include Maglev::Translatable
    include Maglev::SectionsConcern

    ## scopes ##
    scope :by_handles, -> (handles) { where(Maglev::SectionsContentStore.arel_table[:handle].in(handles)) }

    ## translations ##
    translates :sections

    validates :handle, presence: true, uniqueness: true

    def translate_in(locale, source_locale)
      translate_attr_in(:sections, locale, source_locale)
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
