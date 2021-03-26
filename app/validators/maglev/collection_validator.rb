# frozen_string_literal: true

module Maglev
  class CollectionValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      prefix = attribute.to_s.singularize.humanize

      value.each_with_index do |item, index|
        next if item.valid?

        record.errors.add(
          "#{prefix} ##{index}",
          "is invalid, reason(s): #{clean_item_errors(item)}"
        )
      end
    end

    private

    def clean_item_errors(item)
      item.errors.full_messages.join(', ')
    end
  end
end
