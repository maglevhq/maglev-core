# frozen_string_literal: true

module Maglev
  class PagePath < ApplicationRecord
    ## associations ##
    belongs_to :page, class_name: 'Maglev::Page', foreign_key: 'maglev_page_id', inverse_of: 'paths'

    ## scopes ##
    scope :canonical, -> { where(canonical: true) }
    scope :not_canonical, -> { where(canonical: false) }
    scope :by_value, ->(value, locale = nil) { where(value: value, locale: locale || Maglev::I18n.current_locale) }

    ## validations ##
    validates :value, presence: true, exclusion: { in: Maglev.config.reserved_paths }
    validates :value, uniqueness: { scope: %i[locale canonical] }, if: :canonical?
    validates :canonical, uniqueness: { scope: %i[locale maglev_page_id] }, if: :canonical?

    ## callbacks ##
    after_initialize -> { self.locale ||= Maglev::I18n.current_locale }
    before_validation :clean_value!

    ## methods ##

    ## class methods ##

    def self.build_hash(page_id = nil)
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
        .gsub('/', '--')
    end
  end
end
