# frozen_string_literal: true

module Maglev
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
        fetch_original_items.find_by(id: id)
      )
    end

    def fetch_original_items
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

    def collection
      config.collections[collection_id.to_sym]
    end

    def build_item(original_item)
      return nil unless original_item

      Item.new(
        original_item.id,
        original_item[label_field],
        original_item.respond_to?(image_field) ? original_item.public_send(image_field) : nil,
        original_item
      )
    end

    Item = Struct.new(:id, :label, :image_url, :source)
  end
end
