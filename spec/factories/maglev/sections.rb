# frozen_string_literal: true

FactoryBot.define do
  factory :section, class: Maglev::Section do
    id { 'jumbotron' }
    name { 'Jumbotron' }
    theme { build(:theme) }
    category { 'Contents' }
    settings { [] }
    blocks { [] }
    blocks_label { 'List of items' }

    trait :invalid_settings do
      after(:build) do |section|
        section.settings = [
          build(:section_setting, type: 'foo'),
          build(:section_setting),
          build(:section_setting, label: nil)
        ]
      end
    end

    trait :invalid_block do
      after(:build) do |section|
        section.blocks = [
          build(:section_block, type: nil),
          build(:section_block)
        ]
      end
    end
  end
end
