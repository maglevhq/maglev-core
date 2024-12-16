# frozen_string_literal: true

module Maglev
  module Inspector
    def inspect
      string = "#<#{self.class.name}:#{object_id} "
      string << inspect_fields
                .map { |(name, value)| "#{name}: #{value}" }
                .join(', ') << '>'
    end

    private

    def inspect_fields
      []
    end
  end
end
