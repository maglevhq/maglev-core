# frozen_string_literal: true

module Maglev
  # Get an array of maps including the id and name of each page section.
  class GetPageSectionNames
    include Injectable

    dependency :fetch_theme

    argument :page
    argument :only_page_scoped, default: false
    argument :ignore_mirrored, default: false

    # def call
    #   (page.sections || []).map do |section|
    #     definition = theme.sections.find(section['type'])
    #     { id: section['id'], name: definition.human_name }
    #   end
    # end
    # [
    #   { id: 'abc', label: 'Navbar', layoutGroupLabel: 'Header' },
    #   { id: 'dfdf', label: 'Jumbotron', layoutGroupLabel: 'Main' },
    #   { id: 'gdgg', label: 'BigFooter', layoutGroupLabel: 'Footer' }
    # ]
    def call
      fetch_stores.map do |(store, store_definition)|
        # if the store hasn't been translated yet, there won't any sections
        (store&.sections || []).map do |section|
          build_item(section, store_definition)
        end
      end.flatten
    rescue Maglev::Errors::MissingLayout => e
      # for instance, static pages might not have a defined layout
      # AND by default, all the other pages must have a layout_id property
      Rails.logger.warn e.message
      []
    end

    protected

    def theme
      @theme ||= fetch_theme.call
    end

    def fetch_stores      
      layout.groups.map do |store_definition|
        next if only_page_scoped && !store_definition.page_scoped?
        [
          scoped_store.unpublished.find_by(handle: store_definition.id), 
          store_definition
        ]
      end.compact
    end

    def build_item(section, store_definition)
      definition = theme.sections.find(section['type'])
      {
        id: section['id'],
        type: section['type'],
        label: definition.human_name,
        layout_store_id: store_definition.id,
        layout_store_label: store_definition.human_name
      }
    end

    def fetch_sections(store)
      return [] unless store
      store.sections.reject do |section|
        # ignore deleted sections AND sections that are mirrored (if ignore_mirrored = true)
        (section['deleted'] == true) || (ignore_mirrored && section.dig('mirror_of', 'enabled') == true) 
      end
    end

    def layout
      theme.find_layout(page.layout_id).tap do |layout|
        raise Maglev::Errors::MissingLayout, "The page #{page.id} misses the layout_id property" if layout.nil?
      end
    end

    def scoped_store
      Maglev::SectionsContentStore
    end
  end
end
