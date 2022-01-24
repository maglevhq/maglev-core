# frozen_string_literal: true

module Maglev
  # Mimic the Page model
  class StaticPage
    ## concerns ##
    include ActiveModel::Model
    include Maglev::Translatable

    ## attributes ##
    attr_accessor :id, :title_translations, :path_translations,
                  :seo_title_translations, :meta_description_translations,
                  :og_title_translations, :og_description_translations, :og_image_url_translations

    ## translations ##
    translates :title, :path, :seo_title, :meta_description, :og_title, :og_description, :og_image_url

    ## methods ##

    def visible
      true
    end

    def static?
      true
    end

    def sections
      []
    end

    def path_hash
      path_translations
    end

    def lock_version
      0
    end
  end
end
