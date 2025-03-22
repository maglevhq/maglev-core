# frozen_string_literal: true

module Maglev
  # Get an array of maps including the id and name of each page section.
  class GetPageSectionNames
    include Injectable

    dependency :fetch_theme

    argument :page

    # [
    #   { id: 'abc', name: 'Navbar', layoutGroupId: 'header', layoutGroupLabel: 'Header' },
    #   { id: 'dfdf', name: 'Jumbotron', layoutGroupId: 'main', layoutGroupLabel: 'Main' },
    #   { id: 'gdgg', name: 'BigFooter', layoutGroupId: 'footer', layoutGroupLabel: 'Footer' }
    # ]
    def call
      fetch_stores.map do |(store, group)|
        # if the store hasn't been translated yet, there won't any sections
        (store.sections || []).map do |section|
          build_item(section, group)
        end
      end.flatten
    rescue Maglev::Errors::MissingLayout => e
      # for instance, static pages might not have a defined layout
      # AND by default, all the other pages must have a layout_id property
      Rails.logger.warn e.message
      []
    end

    protected

    def build_item(section, group)
      definition = theme.sections.find(section['type'])
      { 
        id: section['id'],
        name: definition.name,
        layout_group_id: group.id,
        layout_group_label: group.label
      }
    end

    def fetch_stores
      handles = layout.groups.inject({}) do |memo, group| 
        memo[group.guess_store_handle(page)] = group
        memo
      end
      scoped_store.by_handles(handles.keys).map do |store|
        [store, handles[store.handle]]
      end
    end

    def theme
      @theme ||= fetch_theme.call
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
