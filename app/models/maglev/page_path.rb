module Maglev
  class PagePath < ApplicationRecord
    
    ## associations ##
    belongs_to :page, class_name: 'Maglev::Page', foreign_key: 'maglev_page_id', inverse_of: 'paths'

    ## scopes ##
    scope :canonical, ->{ where(canonical: true) }
    
    ## validations ##
    validates :value, uniqueness: { scope: 'locale' }, presence: true
    validate :must_be_only_canonical, if: :canonical?

    ## callbacks ##
    after_initialize -> { self.locale ||= Translatable.current_locale }
    before_validation do
      value.blank? ? self.value = 'index' : value.gsub!(%r{(^/|/$)}, '')
    end

    ## methods ##

    private

    def must_be_only_canonical
      return unless page.paths.where(locale: locale, canonical: true).where.not(id: id).any?

      errors.add(:canonical, :taken)
    end
  end
end
