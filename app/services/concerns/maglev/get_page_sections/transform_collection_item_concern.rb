# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::GetPageSections::TransformCollectionItemConcern
  def transform_collection_item_content_setting(content, setting)
    item_id = content&.dig('value', 'id')
    return if item_id.blank?

    item = fetch_collection_items.call(
      collection_id: setting.options[:collection_id],
      id: item_id
    )

    content['value']['label'] = item.label
    content['value']['item'] = item.source
  end
end
# rubocop:enable Style/ClassAndModuleChildren
