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

    ## accessors ##
    attr_accessor :site

    ## methods ##

    def site
      @site || Maglev::Site.first
    end

    def index?
      path == 'index'
    end

    def assign_section_ids
      sections.each do |section|
        section['id'] = SecureRandom.urlsafe_base64(8)
        (section['blocks'] || []).each do |block|
          block['id'] ||= SecureRandom.urlsafe_base64(8)
        end
      end
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
