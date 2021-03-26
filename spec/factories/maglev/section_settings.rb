# frozen_string_literal: true

FactoryBot.define do
  factory :section_setting, class: Maglev::Section::Setting do
    id { 'title' }
    label { 'Title' }
    type { 'text' }
    default { 'Hello world' }
    options { { html: true } }
  end
end
