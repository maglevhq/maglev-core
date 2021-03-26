# frozen_string_literal: true

class Account < ApplicationRecord
  has_secure_password
end
