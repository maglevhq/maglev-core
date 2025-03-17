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
    include Maglev::Translatable
    include Maglev::SectionsConcern # @deprecated Use SectionsContentStore instead

    ## translations ##
    translates :sections # @deprecated Use SectionsContentStore instead

    ## validations ##
    validates :name, presence: true

    ## methods ##
    def api_attributes
      %i[id name]
    end

    def find_section(type)
      ActiveSupport::Deprecation.warn('Not used anymore, replaced by SectionsContentStore')
      sections&.find { |section| section['type'] == type }
    end

    def translate_in(locale, source_locale)
      ActiveSupport::Deprecation.warn('Not used anymore, replaced by SectionsContentStore')
      translate_attr_in(:sections, locale, source_locale)
    end
  end
end
