class Maglev::Inputs::CollectionItem::CollectionItemComponent < Maglev::Inputs::InputBaseComponent

  def selected_item_id
    value.fetch('id', nil)
  end

  def selected_item_label
    value.fetch('label', nil)
  end
end