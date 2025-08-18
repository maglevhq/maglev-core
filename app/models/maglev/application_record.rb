# frozen_string_literal: true

module Maglev
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    private

    def mysql?
      self.class.mysql?
    end

    def self.mysql?
      connection.adapter_name.downcase == 'mysql2'
    end
  end
end
