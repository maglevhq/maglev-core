# frozen_string_literal: true

json.array! @items do |item|
  json.partial!('show', item: item)
end
