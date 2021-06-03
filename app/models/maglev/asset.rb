# frozen_string_literal: true

module Maglev
  class Asset < ApplicationRecord
    include ::Maglev.uploader

    ## validations ##
    validates :file, presence: true

    ## class methods ##

    def self.search(keyword, type, page = nil, per_page = nil)
      all
        .optimized
        .where(keyword.present? ? arel_table[:filename].matches("%#{keyword}%") : nil)
        .where(arel_table[:content_type].matches("%#{type}%"))
        .order(created_at: :desc)
        .page(page || 1)
        .per(per_page || 10)
    end
  end
end
