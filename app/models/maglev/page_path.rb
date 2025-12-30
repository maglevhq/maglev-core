# frozen_string_literal: true

# == Schema Information
#
# Table name: maglev_page_paths
#
#  id             :bigint           not null, primary key
#  canonical      :boolean          default(TRUE)
#  locale         :string           not null
#  value          :string           not null
#  maglev_page_id :bigint
#
# Indexes
#
#  canonical_speed                            (canonical,locale,value)
#  index_maglev_page_paths_on_maglev_page_id  (maglev_page_id)
#  scoped_canonical_speed                     (canonical,maglev_page_id,locale)
#
module Maglev
  class PagePath < ApplicationRecord
    ## associations ##
    belongs_to :page, class_name: 'Maglev::Page', foreign_key: 'maglev_page_id', inverse_of: :paths

    ## scopes ##
    scope :canonical, -> { where(canonical: true) }
    scope :not_canonical, -> { where(canonical: false) }
    scope :by_value, ->(value, locale = nil) { where(value: value, locale: locale || Maglev::I18n.current_locale) }

    ## validations ##
    validates :value, presence: true, exclusion: { in: Maglev.config.reserved_paths }
    validates :value, uniqueness: { scope: %i[locale canonical] }, if: :canonical?
    validates :value, format: { without: /\s/, message: :invalid_path }
    validates :canonical, uniqueness: { scope: %i[locale maglev_page_id] }, if: :canonical?

    ## callbacks ##
    after_initialize -> { self.locale ||= Maglev::I18n.current_locale }
    before_validation :clean_value!

    ## methods ##

    ## class methods ##

    def self.canonical_value_hash(page_id = nil)
      query = page_id ? where(maglev_page_id: page_id) : all
      query.canonical.pluck(:locale, :value).to_h
    end

    private

    def clean_value!
      return if value.blank?

      self.value = clean_value
    end

    def clean_value
      value
        .strip
        .gsub(%r{(^/|/$)}, '')
        .gsub(%r{//+/}, '/')
    end
  end
end
