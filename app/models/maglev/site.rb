# frozen_string_literal: true

module Maglev
  class Site < ApplicationRecord
    ## concerns ##
    include Maglev::Site::LocalesConcern
    # include Maglev::Translatable
    # include Maglev::SectionsConcern # @deprecated Use SectionsContentStore instead

    ## translations ##
    # translates :sections # @deprecated Use SectionsContentStore instead

    ## validations ##
    validates :name, presence: true

    ## methods ##
    def api_attributes
      %i[id name]
    end

    # def find_section(type)
    #   ActiveSupport::Deprecation.warn('Not used anymore, replaced by SectionsContentStore')
    #   sections&.find { |section| section['type'] == type }
    # end

    # def translate_in(locale, source_locale)
    #   ActiveSupport::Deprecation.warn('Not used anymore, replaced by SectionsContentStore')
    #   translate_attr_in(:sections, locale, source_locale)
    # end
  end
end

# == Schema Information
#
# Table name: maglev_sites
#
#  id                    :bigint           not null, primary key
#  domain                :string
#  handle                :string
#  locales               :jsonb
#  lock_version          :integer
#  name                  :string
#  navigation            :jsonb
#  sections_translations :jsonb
#  siteable_type         :string
#  style                 :jsonb
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  siteable_id           :bigint
#  theme_id              :string
#
# Indexes
#
#  index_maglev_sites_on_siteable  (siteable_type,siteable_id)
#
