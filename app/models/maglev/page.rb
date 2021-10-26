# frozen_string_literal: true

module Maglev
  class Page < ApplicationRecord
    ## concerns ##
    include Maglev::Page::PathConcern
    include Maglev::Page::SectionsConcern
    include Maglev::Translatable

    ## translations ##
    translates :title, presence: true
    translates :sections, default: []
    translates :seo_title, :meta_description

    ## scopes ##
    scope :home, ->(locale = nil) { by_path('index', locale) }
    scope :by_id_or_path, ->(id_or_path, locale = nil) { joins(:paths).where(id: id_or_path).or(core_by_path(id_or_path, locale)) }    
    scope :by_path, ->(path, locale = nil) { core_by_path(path, locale).joins(:paths) }
    scope :core_by_path, ->(path, locale = nil) { where(paths: { locale: locale || Maglev::Translatable.current_locale, value: path }) }    

    ## methods ##

    def index?
      path == 'index'
    end

    def self.search(keyword)
      return [] if keyword.blank?

      title = Arel::Nodes::InfixOperation.new('->>', arel_table[:title_translations], Arel::Nodes.build_quoted(Maglev::Translatable.current_locale))
      path = PagePath.arel_table[:value]
      
      query = all.select(Maglev::Page.arel_table[Arel.star], title).distinct.joins(:paths).order(title.asc)
      matching = "%#{keyword}%"
      
      query.where(
        title.matches(matching).or(
          path.matches(matching).and(path.eq(Maglev::Translatable.current_locale))
        )
      )
    end    
  end
end
