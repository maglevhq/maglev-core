# frozen_string_literal: true

class Account < ApplicationRecord
  has_secure_password
end

# == Schema Information
#
# Table name: accounts
#
#  id              :bigint           not null, primary key
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
