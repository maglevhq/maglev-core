# frozen_string_literal: true

module Maglev
  class Page < ApplicationRecord
    ## concerns ##
    include Maglev::Page::SectionsConcern

    ## validations ##
    validates :title, presence: true
    validates :path, uniqueness: true, presence: true

    ## callbacks ##
    before_validation :clean_path

    ## scopes ##
    scope :by_id_or_path, ->(id_or_path) { where(id: id_or_path).or(where(path: id_or_path)) }
    scope :home, -> { where(path: 'index') }

    ## methods ##

    def index?
      path == 'index'
    end

    def self.search(keyword)
      return [] if keyword.blank?

      query = all.order(title: :asc)
      matching = "%#{keyword}%"

      query.where(
        arel_table[:title].matches(matching).or(
          arel_table[:path].matches(matching)
        )
      )
    end

    private

    def clean_path
      path.blank? ? self.path = 'index' : path.gsub!(%r{(^/|/$)}, '')
    end
  end
end
