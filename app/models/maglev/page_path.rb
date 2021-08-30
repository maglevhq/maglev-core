module Maglev
  class PagePath < ApplicationRecord
    ## associations ##
    belongs_to :page, class_name: 'Maglev::Page', foreign_key: 'maglev_page_id', inverse_of: 'paths'

    ## callbacks ##
    before_validation do
      value.blank? ? self.value = 'index' : value.gsub!(%r{(^/|/$)}, '')
    end

    ## validations ##
    validates :value, uniqueness: { scope: :page }, presence: true
  end
end
