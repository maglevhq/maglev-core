# frozen_string_literal: true

module Maglev
  class Page < ApplicationRecord
    ## concerns ##
    include Maglev::Translatable
    include Maglev::Page::PathConcern
    include Maglev::Page::SectionsConcern
    include Maglev::Page::SearchConcern

    ## translations ##
    translates :title, presence: true
    translates :sections, default: []
    translates :seo_title, :meta_description

    ## scopes ##
    scope :home, ->(locale = nil) { by_path('index', locale) }
    scope :by_id_or_path, lambda { |id_or_path, locale = nil|
                            joins(:paths).where(id: id_or_path).or(core_by_path(id_or_path, locale))
                          }
    scope :by_path, ->(path, locale = nil) { core_by_path(path, locale).joins(:paths) }
    scope :core_by_path, lambda { |path, locale = nil|
                           where(paths: { locale: locale || Maglev::Translatable.current_locale, value: path })
                         }

    ## methods ##

    def index?
      path == 'index'
    end
  end
end
