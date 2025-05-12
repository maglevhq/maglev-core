# frozen_string_literal: true

if @item
  json.partial!('show', item: @item)
else
  json.nil!
end
