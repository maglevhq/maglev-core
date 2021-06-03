# frozen_string_literal: true

module Maglev
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
