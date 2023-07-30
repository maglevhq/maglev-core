# frozen_string_literal: true

module Maglev
  # Find item(s) from a collection defined in the Maglev config file.
  # If the id is specified, then look for an item, it not, look for all the items
  # matching a keyword.
  class FetchCollectionItems
    include Injectable

    dependency :config
    dependency :fetch_site

    argument :collection_id
    argument :id, default: nil
    argument :keyword, default: nil
    argument :max_items, default: 10

    def call
      if id
        fetch_item
      else
        fetch_items
      end
    end

    private

    def fetch_items
      fetch_original_items.map do |original_item|
        build_item(original_item)
      end
    end

    def fetch_item
      build_item(
        id == 'any' ? fetch_original_items.first : fetch_original_items.find_by(id: id)
      )
    end

    def fetch_original_items
      return default_fetch_original_items unless fetch_method_name

      model_class.public_send(fetch_method_name,
                              site: fetch_site.call,
                              keyword: keyword,
                              max_items: max_items)
    end

    def default_fetch_original_items
      model_class
        .where(keyword.present? ? model_class.arel_table[label_field].matches("%#{keyword}%") : nil)
        .limit(max_items)
        .order(label_field)
    end

    def model_class
      collection[:model].constantize
    end

    def label_field
      collection.dig(:fields, :label)&.to_sym
    end

    def image_field
      collection.dig(:fields, :image)&.to_sym
    end

    def item_label(item)
      label_field && item.respond_to?(label_field) ? item.public_send(label_field) : nil
    end

    def item_image(item)
      image_field && item.respond_to?(image_field) ? item.public_send(image_field) : nil
    end

    def fetch_method_name
      collection[:fetch_method_name]
    end

    def collection
      config.collections[collection_id.to_sym].tap do |collection|
        next if collection

        raise "[Maglev] unregistered '#{collection_id}' collection in the Maglev configuration."
      end
    end

    def build_item(original_item)
      return nil unless original_item

      Item.new(
        original_item.id,
        item_label(original_item),
        item_image(original_item),
        original_item
      )
    end

    Item = Struct.new(:id, :label, :image_url, :source)
  end
end
