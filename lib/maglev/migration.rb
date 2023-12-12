# frozen_string_literal: true

module Maglev
  module Migration
    private

    def primary_key_type
      primary_key_type_setting || :primary_key
    end

    def foreign_key_type
      primary_key_type_setting || :bigint
    end

    def primary_key_type_setting
      config = Rails.configuration.generators
      config.options[config.orm][:primary_key_type]
    end
  end
end
