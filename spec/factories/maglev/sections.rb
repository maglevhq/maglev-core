# frozen_string_literal: true

FactoryBot.define do
  factory :section, class: 'Maglev::Section' do
    id { 'jumbotron' }
    name { 'Jumbotron' }
    theme { build(:theme) }
    category { 'content' }
    settings do
      [
        build(:section_setting),
        build(:section_setting, id: 'body', label: 'Body')
      ]
    end
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

    trait :navbar do
      id { 'navbar' }
      name { 'Navbar' }
      category { 'headers' }
      settings do
        [build(:section_setting, id: 'logo', label: 'Logo', type: 'image', default: 'awesome-logo.png')]
      end
      blocks_presentation { 'tree' }
      blocks do
        [
          build(:section_block,
                type: 'menu_item',
                settings: [
                  build(:section_setting, id: 'label', label: 'Label'),
                  build(:section_setting, :link)
                ])
        ]
      end
    end

    trait :navbar_with_sample do
      sample do
        {
          settings: {
            logo: 'another-awesome-logo.png'
          },
          blocks: [
            {
              type: 'menu_item',
              settings: {
                label: 'Home',
                link: '/'
              }
            },
            {
              type: 'menu_item',
              settings: {
                label: 'About us',
                link: '/about-us'
              },
              children: [
                {
                  type: 'menu_item',
                  settings: {
                    label: 'Our company',
                    link: '/'
                  }
                },
                {
                  type: 'menu_item',
                  settings: {
                    label: 'Our staff',
                    link: '/'
                  }
                }
              ]
            }
          ]
        }
      end
    end
  end
end
