# frozen_string_literal: true

# == Schema Information
#
# Table name: maglev_sections_content_stores
#
#  id                    :bigint           not null, primary key
#  container_type        :string
#  handle                :string           default("WIP"), not null
#  lock_version          :integer
#  published             :boolean          default(FALSE)
#  sections_translations :jsonb
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  container_id          :string
#  maglev_page_id        :bigint
#
# Indexes
#
#  index_maglev_sections_content_stores_on_handle          (handle)
#  index_maglev_sections_content_stores_on_maglev_page_id  (maglev_page_id)
#  maglev_sections_content_stores_container_and_published  (container_id,container_type,published) UNIQUE
#  maglev_sections_content_stores_handle_and_page_id       (handle,maglev_page_id,published) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (maglev_page_id => maglev_pages.id)
#
module Maglev
  class SectionsContentStore < ApplicationRecord
    ## concerns ##
    include Maglev::Translatable
    include Maglev::SectionsConcern

    ## constants
    SITE_HANDLE = '_site' # handle for the global site scoped sections
    
    ## associations ##
    belongs_to :page, class_name: 'Maglev::Page', foreign_key: 'maglev_page_id', optional: true, inverse_of: :sections_content_stores

    ## scopes ##
    scope :by_handles, ->(handles) { where(Maglev::SectionsContentStore.arel_table[:handle].in(handles)) }
    scope :published, -> { where(published: true) }
    scope :unpublished, -> { where(published: false) }
    
    ## validations ##
    validates :handle, presence: true, uniqueness: { scope: [:maglev_page_id, :published] }

    ## translations ##
    translates :sections    

    ## methods ##

    def translate_in(locale, source_locale)
      translate_attr_in(:sections, locale, source_locale)
    end

    ## class methods ##

    def self.site_scoped(attributes = {})
      find_or_create_by(attributes.merge(handle: ::Maglev::SectionsContentStore::SITE_HANDLE, published: false))
    end
  end
end
