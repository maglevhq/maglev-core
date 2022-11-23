# frozen_string_literal: true

FactoryBot.define do
  factory :section_setting, class: 'Maglev::Section::Setting' do
    id { 'title' }
    label { 'Title' }
    type { 'text' }
    default { 'Hello world' }
    options { { html: true } }

    trait :link do
      id { 'link' }
      label { 'Link' }
      type { 'link' }
      options { { with_text: true } }
    end
  end
end
