# frozen_string_literal: true

module Maglev
  # Get an array of maps including the id and name of each page section.
  class GetPageSectionNames
    include Injectable

    dependency :fetch_theme

    argument :page
    argument :available_for_mirroring, default: false
    argument :already_mirrored_section_ids, default: []

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
        fetch_sections(store).map do |section|
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
        next unless accept_store?(store_definition)

        [
          scoped_store.unpublished.find_by(handle: store_definition.id, page: page),
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

      store.sections.select do |section|
        accept_section?(section)
      end
    end

    def layout
      theme.find_layout(page.layout_id).tap do |layout|
        raise Maglev::Errors::MissingLayout, "The page #{page.id} misses the layout_id property" if layout.nil?
      end
    end

    def accept_store?(store_definition)
      return true unless available_for_mirroring

      # when getting sections available for mirroring, we only want to return page scoped sections
      store_definition.page_scoped?
    end

    def accept_section?(section)
      # ignore deleted sections
      return false if section['deleted'] == true

      # the next conditions are only relevant if available_for_mirroring = true
      return true unless available_for_mirroring

      # we don't want to return site scoped sections
      return false if theme.sections.find(section['type']).site_scoped?

      # we don't want to return mirrored sections OR sections that are already mirrored
      section.dig('mirror_of', 'enabled') != true && !already_mirrored_section_ids.include?(section['id'])
    end

    def scoped_store
      Maglev::SectionsContentStore
    end
  end
end
