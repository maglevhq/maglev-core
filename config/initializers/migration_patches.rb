# frozen_string_literal: true

module ActiveRecord
  class Migration
    def mysql?
      connection.adapter_name.downcase == 'mysql2'
    end
  end
end
