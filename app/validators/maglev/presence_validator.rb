# frozen_string_literal: true

module Maglev
  class PresenceValidator < ActiveModel::Validations::PresenceValidator
    def validate_each(record, attribute, value)
      value = 'false' if value == false # trick the validator
      super
    end

    private

    def clean_item_errors(item)
      item.errors.full_messages.join(', ')
    end
  end
end
