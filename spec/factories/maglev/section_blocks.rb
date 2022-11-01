# frozen_string_literal: true

FactoryBot.define do
  factory :section_block, class: 'Maglev::Section::Block' do
    name { 'Slide' }
    type { 'slide' }
    settings { [] }
  end
end
