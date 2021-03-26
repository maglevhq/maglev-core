# frozen_string_literal: true

json.data do
  json.array! @assets do |asset|
    json.partial!('show', asset: asset)
  end
end

json.partial!('pagination', records: @assets)
