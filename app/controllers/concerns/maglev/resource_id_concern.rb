# frozen_string_literal: true

module Maglev
  module ResourceIdConcern
    def resource_id
      # A standard UUID code contains 32 hex digits along with 4 "-"" symbols
      Maglev.uuid_as_primary_key? && params[:id] ? params[:id][0..35] : params[:id]
    end
  end
end
