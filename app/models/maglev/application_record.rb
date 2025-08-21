# frozen_string_literal: true

module Maglev
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    def self.mysql?
      connection.adapter_name.downcase == 'mysql2'
    end

    private

    def mysql?
      self.class.mysql?
    end
  end
end
