module Maglev
  class LocalesType < ActiveRecord::Type::Json
    def deserialize(value)
      (super || []).map { |attributes| Maglev::Site::Locale.new(**attributes.symbolize_keys) }
    end
  end
end