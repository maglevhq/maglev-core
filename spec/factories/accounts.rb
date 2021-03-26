# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    email { 'john@awesome-site.local' }
    password { 'easyone' }
  end
end
