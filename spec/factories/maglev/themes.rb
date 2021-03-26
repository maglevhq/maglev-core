# frozen_string_literal: true

FactoryBot.define do
  factory :theme, class: Maglev::Theme do
    id { 'simple' }
    name { 'Simple' }
    description { 'Super simple theme' }
    sections { [] }
  end
end
