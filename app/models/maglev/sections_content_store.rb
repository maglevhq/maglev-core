# frozen_string_literal: true

module Maglev
  class SectionsContentStore < ApplicationRecord
    ## concerns ##
    include Maglev::Translatable
    include Maglev::SectionsConcern

    ## constants
    SITE_HANDLE = '_site' # handle for the global site scoped sections

    ## associations ##
    belongs_to :page, class_name: 'Maglev::Page', foreign_key: 'maglev_page_id', optional: true, inverse_of: :stores

    ## scopes ##
    scope :by_handles, ->(handles) { where(Maglev::SectionsContentStore.arel_table[:handle].in(handles)) }

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
# Table name: maglev_sections_content_stores
#
#  id                    :bigint           not null, primary key
#  handle                :string           not null
#  lock_version          :integer
#  sections_translations :jsonb
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_maglev_sections_content_stores_on_handle  (handle)
#
